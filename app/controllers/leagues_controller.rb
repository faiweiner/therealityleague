require 'date'

class LeaguesController < ApplicationController

	before_action :check_if_logged_in
	before_action :save_login_state, only: [:new, :search, :results]
	before_action :get_league, only: [:display, :edit, :invite]
	before_action :private_restriction, only: [:display]
	before_action :commissioner_restriction, only: [:edit]
	skip_before_action :verify_authenticity_token, only: [:results]

	attr_accessor :name, :league_key, :league_password
	
	def index
		if @current_user.admin?
			@leagues = League.where(active: true).order(:created_at)
			@past_leagues = League.where(active: false).order(:created_at)
		elsif @current_user.leagues.any?
			@leagues = @current_user.leagues.where(active: true).order(:created_at)
			@past_leagues = @current_user.leagues.where(active: false).order(:created_at)			
		else
			flash[:notice] = "Oh snapssss!"
			flash[:subtext] = "Looks like you aren't part of any league yet. What would you like to do?"
			flash[:color] = "warning"

			flash[:button] = []
			flash[:button][0] = ["Find and Join a League", "/leagues/search", "btn btn-sm btn-default"]
			flash[:button][1] = ["Create a League", "/leagues/new", "btn btn-sm btn-default"]
			return
		end
		
		@leagues_imgs = Hash.new

		if @leagues
			@leagues.each do |league|
				if league.commissioner_id == @current_user.id
					comm_icon = "/assets/icons/star.png"
					alt1 = "comm star"
					action = "Manage"
				else
					comm_icon = nil
					alt1 = nil
					action = "View"
				end
				if league.public_access?
					private_icon = nil
					alt2 = nil
				else
					private_icon = "/assets/icons/private.png"
					alt2 = "private"
				end
				if league.locked?
					status = "Commenced"
				elsif league.draft_deadline.future?
					status = "Drafting Period"
				else
					status = "--"
				end
				@leagues_imgs[league] = [comm_icon, alt1, private_icon, alt2, status]
			end
		end
	end

	def new
		@league = League.new 
		if @current_user == nil
			flash[:notice] = "Looks like you haven't registered yet - please sign up before creating a new league."
			flash[:color] = "invalid"
			redirect_to new_user_path
		end
		
		@export_show_list = Show.all
		@export_season_list = Season.where(expired: false)
	end
	
	def create
		@league = League.new league_params
		@league.season_id = params[:league][:season_id]
		season = Season.where(name: params[:league][:season_id])
		
		if @league.save
			# Automatically adds the commissioner (user) as participant of the league
			@league.users << [@current_user]
			# get customized text based on type
			@access_type = nil
			if @league.public_access == true
				@access_type = "public"
			else
				@access_type = "private"
			end
			# automatically creates a league roster for the user
			roster = Roster.create(user_id: @current_user.id, league_id: @league.id)
			roster.save
			
			flash[:notice] = "You\'ve successfully created a #{@access_type} league!"
			# Once someone signs up, they currently need to log in. Better to have automatically log-in?
			flash[:color] = "success"
			
			redirect_to league_path(@league.id)
		else
			flash[:notice] = "Something went wrong and we were unable to save your league"
			flash[:color] = "danger"
			render :new
		end
	end

	def edit
		# automatic redirect out of page if not a commissioner
		@league_show_id = @league.season.show_id
		@league_season_id = @league.season_id
		@league_type = @league.type
	end

	def update
		@league = League.find(params[:id]).becomes(League)
		symbol = "#{@league.type.downcase}"
		@league.update_attributes league_params
		redirect_to league_path(@league.id)
	end

	def destroy
		@league = League.find(params[:id])
		@league.destroy
		redirect_to leagues_path
	end

	def display
		@show = @league.season.show
		@participants = @league.users
		@rules_collection = get_schemes(@show)

		@show_title = "#{@show.name}: #{@league.season.name}"
		board_type = ""
		case @league.type
		when "Fantasy"
			board_type = "roster"
		when "Elimination"
			board_type = "bracket"
		end

		@participants_ids_collection = @participants.pluck(:id)
		
		@action_panel = Hash.new
		@alert = Hash.new
		if @participants.include? @current_user
			@action_panel[:include_current_user] = true
		else
			@action_panel[:include_current_user] = false
		end

		spots = nil
		if @league.participant_cap.present?
			spots = @league.participant_cap - @participants.count
		end
		
		# ============ CASES ============ #
		case @league.type
		when "Fantasy"
			join_path = rosters_path(@league.id)
		when "Elimination"
			join_path = rounds_create_path(@league.id)
		end

		# ============ ALERTS ============ #
		@status = ""
		@alert_class = ""
		@alert = []
		@invite_button = []
		
		# ------ leagues ACTIVE ------ #
		if @league.active? & @league.locked == false
			# ------ member of the league ------ #
			if @league.users.include? @current_user
				# ------ commissioner of the league ------ #
				if @league.commissioner_id == @current_user.id
					# ------ solo memmber ------ #
					if spots
						if spots == 0
						elsif @participants.count == 1
							@status = "available"
							@alert_class = "warning"
							@alert[0] = ""
							@alert[1] = "Invite friends to join the league before the league commences on #{@league.draft_deadline.strftime("%D")}!"
							@invite_button[0] = "Invite Participants"
							@invite_button[1] = league_invite_path(@league.id)
							@invite_button[2] = "btn btn-sm btn-default"						
						elsif spots < 3
							@status = "limited"
							@alert_class = "danger"
							@alert[0] = "Only #{spots} #{"spot".pluralize(spots)} left in this league!"
							@alert[1] = ""
							@invite_button[0] = "Do something"
							@invite_button[1] = "#"
							@invite_button[2] = "btn btn-sm btn-default"												
						end
					elsif @participants.count < 2
						@status = "available"
						@alert_class = "warning"
						@alert[0] = ""
						@alert[1] = "Invite friends to join the league before the league commences!"
						@invite_button[0] = "Invite Participants"
						@invite_button[1] = league_invite_path(@league.id)
						@invite_button[2] = "btn btn-sm btn-default"
					end
				# ------ NOT the commissioner ------ #
				else
				end
			# ------ NOT member of the league ------ #
			else
				# ------ no participant cap------ #
				if spots.nil?
					@status = "available"
					@alert_class = "info"
					@alert[0] = "This league is open to the public."
					@alert[1] = ""
					@alert[2] = "Last day to join and submit a #{board_type} is #{@league.draft_deadline.strftime("%D")}."
					@invite_button[0] = "Join This League"
					@invite_button[1] = join_path
					@invite_button[2] = "btn btn-sm btn-default"
					@invite_button[3] = "join"
					@invite_button[4] = @league.id
					@invite_button[5] = "POST"		
				# ------ participant cap exists ------ #
				else
					if spots == 0
						@status = "full"
						@alert_class = "danger"
						@alert[0] = "This league is completely full."
						@alert[1] = "Would you like to search other available leagues?"
						@invite_button[0] = "Search other leagues"
						@invite_button[1] = "/leagues/search"
						@invite_button[2] = "btn btn-sm btn-default"
					elsif spots <= 3
						# if there is a cap and less than 3 spots left
						@status = "danger"
						@alert_class = "warning"				
						@alert[0] = "HURRY!" 
						@alert[1] = "There are only #{spots} #{"spot".pluralize(spots)} left in this league. Click \"Join League\" now before the league fills up!"
						@alert[2] = "Last day to submit a #{board_type} is #{@league.draft_deadline.strftime("%D")}."
						@invite_button[0] = "Join This League"

						@invite_button[1] = join_path
						@invite_button[2] = "btn btn-sm btn-default"
						@invite_button[3] = "join"
						@invite_button[4] = @league.id
						@invite_button[5] = "POST"	
					else
						# if there is a cap and there are some room left
						@status = "limited"
						@alert_class = "warning"
						@alert[0] = "#{spots} #{"spot".pluralize(spots)} left in this league."
						@alert[1] = "Join today before this league fills up!"
						@alert[2] = "Last day to submit a #{board_type} is #{@league.draft_deadline.strftime("%D")}."
						@invite_button[0] = "Join This League"
						@invite_button[1] = join_path
						@invite_button[2] = "btn btn-sm btn-default"
						@invite_button[3] = "join"
						@invite_button[4] = @league.id
						@invite_button[5] = "POST"								
					end
				end
			end

		# ------ leagues INACTIVE ------ #
		elsif @league.locked == true
			@status = "locked"
			@alert_class = "success"
			@alert[0] = "The league has commenced."
			@alert[1] = ""
			@alert[2] = "#{@show_title} premieres on #{@league.season.premiere_date.strftime("%D")} #{Time.zone}"
			@invite_button[0] = ""
			@invite_button[1] = ""
			@invite_button[2] = ""	
		# ------ leagues INACTIVE ------ #
		else
			@status = "inactive"
			@alert_class = "warning"
			@alert[0] = "This league is no longer active."
			@alert[1] = ""
			@alert[2] = "Why not search for another league to join?"
			@invite_button[0] = "Search other leagues"
			@invite_button[1] = "/leagues/search"
			@invite_button[2] = "btn btn-sm btn-default"		
		end

		case @league.type

		# ========== FOR ELIMINATION ========== #
		when "Elimination"
			@rounds_collection = @league.rounds.where(user_id: @current_user.id)
			@rounds_contestants_collection = []
			@rounds_collection.each do |round| 
				round.contestants.each do |contestant|
					@rounds_contestants_collection << contestant
				end
			end

			@rounds_contestants_collection.uniq!

			@participants_ranking = {}
			@participants.each_with_index do |participant, i|
				@participants_ranking[i] = {
					:participant => participant,
					:score => participant.calculate_total_rounds_points(@league),
					:rounds_collection => @rounds_collection,
					:rounds_contestants_collection => @rounds_contestants_collection
				}
			end
			@ranking = @participants_ranking.map.sort_by{|k, v| -v[:score]}

			deadline_alert = nil

			@alert_messages = [deadline_alert]
		# ========== FOR FANTASY ========== #
		when "Fantasy"
			@participants_ranking = {}
			# @participants.each_with_index do |participant, i|
			# 	@participants_ranking[i] = {
			# 		:participant => participant,
			# 		:score => participant.roster.calculate_total_roster_points
			# 	}
			# end
			# @ranking = @participants_ranking.map.sort_by{|k, v| -v[:score]}

			@participants_roster_id = {}
			@participants_roster_total = {}
			@participants_roster_weekly = {}		
				
			@participants.each do |participant|
				# get Roster ID
				roster_id = participant.rosters.where(league_id: @league.id).pluck(:id)[0]
				@participants_roster_id.store(participant.username, roster_id)
				# get Roster Total
				roster_total = Roster.find(roster_id).calculate_total_roster_points
				@participants_roster_total.store(participant.username, roster_total)

				# # get Roster Rounds
				# roster_rounds_points = []
				# roster_rounds = Roster.find(roster_id).rounds.pluck(:id)		# stores hash of { round_id => points }
				# roster_rounds.each do |id| 
				# 	round = Round.find(id)
				# 	roster_rounds_points << [id, round.calculate_round_points]
				# end
				# @participants_roster_weekly.store(participant.username, {roster_rounds_id: roster_rounds_points})
			end
			# sort roster to reflect current leads
			@participants_roster_total_sorted = @participants_roster_total.sort_by{|key, value| value}.reverse!
			
			deadline_alert = nil

			@league.rosters.where(user_id: @current_user.id).empty?

			deadline_alert = "Last day to submit a roster is on #{@league.draft_deadline.strftime('%B %d')}."
		end
	end

	def search
		if params[:search]
			query = params[:search]
			search_term = regex_validation(query)
			case search_term 
			when "empty"
				flash[:notice] = "Empty search query - please enter a search term"
				flash[:color] = "invalid"
			when "league_key"
				@league_result = League.search_by_key(query)[0]
			else
				@league_results = League.all.order("created_at ASC")
			end
			# # if query is a league name, presumably having space and/or \' between words
			# elsif regex_validation(query)
			# 	raise
			# 	shows_list = Show.search_show(query)
			# 	shows_list.each do |show|
			# 		@show = Show.find(show.id)
			# 	end
			# 	@league_results	= League.search_by_show(@show.id)
			# else ""
			# 	flash[:notice] = "Search query empty - please enter league name, key, or show name."
			# 	flash[:color] = "invalid"
			# 	@league_results = League.all.order("created_at ASC")
			# 	raise "no you shouldn't get here!"
			# end
		# If there is no query (direct visit to search)
		else
			@league_results_participant = League.includes(:users).where(:active => true) 	#
			@league_results_nonparticipant = League.all
			@private_leagues = League.where(:public_access => false) if @current_user.admin? 
		end
	end

	def invite
	end

	def access
		if params[:league_key].empty? || params[:password].empty?
			flash[:notice] = "Invalid entry. Please enter both league key and password."
			flash[:color] = "invalid"
			redirect_to leagues_search_path
		elsif params[:league_key].present? && params[:password].present?
			@league = League.where(league_key: params[:league_key]).uniq.first
			if @league.present? && @league.league_password == params[:password]
				if @league.active?
					flash[:notice] = "Access granted!"
					flash[:color] = "valid"
				else
					flash[:notice] = "This league is no longer active."
					flash[:color] = "warning"
				end
				params[:league] = @league.id
				redirect_to	league_path(@league.id)
			elsif @league.nil? && @league.league_password != params[:password]
				flash[:notice] = "Invalid league password. Please try again."
				flash[:color] = "invalid"
				redirect_to leagues_search_path
			else
				flash[:notice] = "Invalid league key. Please try again"
				flash[:color] = "invalid"
				redirect_to leagues_search_path				
			end
		
		end
	end

	private

	# standard strong params practice
	def league_params
		params.require(:league).permit(
			:name, 
			:commissioner_id, 
			:season_id, 
			:public_access, 
			:type,
			:participant_cap, 
			:draft_deadline,
			:draft_order, 
			:scoring_system, 
			:league_key, 
			:league_password, 
			:active)
	end

	def remaining(date, event)
		intervals = [["day", 1], ["hour", 24], ["minute", 60], ["second", 60]]
		elapsed = DateTime.now - date
		tense = elapsed > 0 ? "since" : "until"
		interval = 1.0
		parts = intervals.collect do |name, new_interval|
			interval /= new_interval
			number, elapsed = elapsed.abs.divmod(interval)
			"#{number.to_i} #{name}#{"s" unless number == 1}"
		end
		puts "#{parts.join(", ")} #{tense} #{event}."
	end

	def get_league
		@league = League.includes(:users, :season).find(params[:id]).becomes(League)
		@league.unlock_league if @league.locked == true
	end

	def private_restriction
		@league = League.find(params[:id])
		if (@league.public_access? == false) && (@leagues.users.include? @current_user == false)
		# if league is private AND @current_user is not a member
			flash[:notice] = "You do not have permission to access this private league."
			flash[:color] = "danger"
			redirect_to leagues_path
		end
	end

	def commissioner_restriction
		@league = League.find(params[:id])
		if @current_user.nil? || @league.commissioner_id != @current_user.id
			flash[:notice] = "You are not authorized to edit the current league. Please contact the site administrator if you have any questions."
			flash[:color] = "alert-danger"			
			redirect_to league_path(params[:id])
		end
	end

end
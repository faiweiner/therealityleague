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
			all_leagues = League.where(active: true).order(:created_at)
			@leagues = all_leagues.find_all {|league| league.users.include? @current_user}
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
		board_count = 0
		case @league.type
		when "Fantasy"
			board_type = "roster"
			board_count = @league.rosters.count
		when "Elimination"
			board_type = "bracket"
			board_count = @league.rounds.count
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
		
		cases = []

		if @league.commissioner_id == @current_user.id  # index[0] = commissioner
			cases[0] = "commissioner" 
		else 																						# index[0] = participant or non-participant
			if @league.users.include? @current_user 			 
				cases[0] = "participant" 
			else
				cases[0] = "non-participant"
			end
		end

		if @league.active? 	# index[1] active, index[2]...[5]
			cases[1] = "active" 		
			if @league.locked? 	# index[2] = locked, index[3]...[5] == nil
				cases[2] = "locked" 
				cases[3], cases[4], cases[5] = nil
			else 								# index[2] = unlocked, index[3]..[5]
				cases[2] = "unlocked" 
				# index[3] = public?
				if @league.public_access? then cases[3] = "public" else cases[3] = "private" end
				
				if @league.participant_cap?	# index[4] = cap exists, index[5]...
					cases[4] = "cap"  						# index[5] = spots within cap
					if spots == 0 then cases[5] = :F1 elsif spots < 3 then cases[5] = :F2 else cases[5] = :F3 end
				else 												# if index[4] =  no cap, index[5] = nil
					cases[4] = "no_cap" 
					cases[5] = nil # nil because spot is nil
				end
			end
		else 								# index[1] inactive, index[2]...[5] == nil
			cases[1] = "inactive" 
			cases[2], cases[3], cases[4], cases[5] = nil
		end
	
		case cases
		when 	["commissioner", "active", "locked", nil, nil, nil ],
					["participant", "active", "locked", nil, nil, nil ]
			argument = "all-locked"
		when 	["commissioner", "active", "unlocked", "private", "no_cap", nil], 
					["commissioner", "active", "unlocked", "public", "no_cap", nil]
			argument = "comm-unlocked-nocap"
		when 	["commissioner", "active", "unlocked", "private", "cap", :F1], 
					["commissioner", "active", "unlocked", "private", "cap", :F2],
					["commissioner", "active", "unlocked", "private", "cap", :F3],
					["commissioner", "active", "unlocked", "public", "cap", :F1],
					["commissioner", "active", "unlocked", "public", "cap", :F2],
					["commissioner", "active", "unlocked", "public", "cap", :F3]
			argument = "comm-unlocked-cap"
		when 	["commissioner", "inactive", nil, nil, nil, nil], 
					["participant", "inactive", nil, nil, nil, nil]
			argument = "all-inactive"
		when 	["participant", "active", "unlocked", "private", "no_cap", nil], 
					["participant", "active", "unlocked", "private", "cap", :F1],
					["participant", "active", "unlocked", "private", "cap", :F2],
					["participant", "active", "unlocked", "private", "cap", :F3],
					["participant", "active", "unlocked", "public", "no_cap", nil],	
					["participant", "active", "unlocked", "public", "cap", :F1],
					["participant", "active", "unlocked", "public", "cap", :F2],
					["participant", "active", "unlocked", "public", "cap", :F3]
			argument = "p-unlocked"
		when 	["non-participant", "active", "unlocked", "public", "no_cap", nil]	
			argument = "np-unlocked-public-nocap"
		when 	["non-participant", "active", "unlocked", "private", "no_cap", nil]
			argument = "np-unlocked-private-cap"
		when	["non-participant", "active", "unlocked", "private", "cap", :F1],
					["non-participant", "active", "unlocked", "private", "cap", :F2],
					["non-participant", "active", "unlocked", "private", "cap", :F3]
			argument = "np-unlocked-private-cap"		
		when	["non-participant", "active", "unlocked", "public", "cap", :F1],
					["non-participant", "active", "unlocked", "public", "cap", :F2],
					["non-participant", "active", "unlocked", "public", "cap", :F3]
			argument = "np-unlocked-public-cap"
		end

		case argument
		when "all-locked"							 			# comm & p, active, LOCKED, public OR private (doesn't matter if there's a cap or not)
			@status = "locked"
			@alert_class = "alert-success"
			@alert[0] = "This #{@league.type} league has commenced."
			@alert[1] = "#{board_type.pluralize.capitalize} are now locked and can no longer be edited."
			@alert[2] = "#{@show_title} premieres on #{@league.season.premiere_date.strftime("%D")} #{Time.zone}"
			@invite_button[0] = nil
			@invite_button[1] = nil
			@invite_button[2] = nil			
		when "comm-unlocked-nocap" 					# comm, active, UNLOCKED, no cap, private OR public
			@status = "open"
			@alert_class = "alert-success"
			@alert[0] = "Your #{@league.type} league is open."
			@alert[1] = "#{board_type.pluralize.capitalize} can be edited up to the league's deadline on #{@league.draft_deadline.strftime("%D")}."
			@alert[2] = "#{@show_title} premieres on #{@league.season.premiere_date.strftime("%D")} #{Time.zone}"
		when 	"comm-unlocked-cap" 						# comm, active, UNLOCKED, cap, private OR public
			case cases[5]
			when :F1 # spots == 0
				@status = "full"
				@alert_class = "alert-success"
				@alert[0] = "Your league is currently full."
				@alert[1] = ""
				@invite_button[0] = nil
				@invite_button[1] = nil
				@invite_button[2] = nil	
			when :F2 # spots less than 3
				@status = "limited"
				@alert_class = "alert-danger"
				@alert[0] = "Only #{spots} #{"spot".pluralize(spots)} left in this league!"
				@alert[1] = ""
				@invite_button[0] = nil
				@invite_button[1] = nil
				@invite_button[2] = nil	
			else :F3 # all other cases
				@status = "available"
				@alert_class = "alert-warning"
				@alert[0] = ""
				@alert[1] = "Invite friends to join the league before the league commences on #{@league.draft_deadline.strftime("%D")}!"
				@invite_button[0] = "Invite Participants"
				@invite_button[1] = league_invite_path(@league.id)
				@invite_button[2] = "btn btn-sm btn-default"			
			end	
		when 	"all-inactive"									# comm & p, inactive
			@status = "inactive"
			@alert_class = "warning"
			@alert[0] = "This league is no longer active"
			@alert[1] = "as #{@show_title} has concluded."
			@alert[2] = "Would you like to revive this league for the next season of #{@league.show}?"
			@invite_button[0] = "Revive League"
			@invite_button[1] = "#"
			@invite_button[2] = "btn btn-sm btn-default"		
		when 	"p-locked" 										# p, active, LOCKED, public OR private (doesn't matter if there's a cap or not)
			@status = "locked"
			@alert_class = "alert-success"
			@alert[0] = "Your #{@league.type} league has commenced."
			@alert[1] = "#{board_type.pluralize.capitalize} are now locked and can no longer be edited."
			@alert[2] = "#{@show_title} premieres on #{@league.season.premiere_date.strftime("%D")} #{Time.zone}"
			@invite_button[0] = nil
			@invite_button[1] = nil
			@invite_button[2] = nil		
		when 	"p-unlocked" 									# p, active, UNLOCKED, public OR private, cap OR no cap
			@status = "unlocked"
			@alert_class = "alert-warning"
			@alert[0] = "#{@show_title} premieres on #{@league.season.premiere_date.strftime("D")}."
			@alert[1] = "Be sure to submit your #{board_type} before the league's deadline on #{@league.draft_deadline.strftime("D")}."
			@invite_button[0] = nil
			@invite_button[1] = nil
			@invite_button[2] = nil			
		when 	"np-unlocked-public-nocap",	"np-unlocked-private-nocap"		# p, active, UNLOCKED, public, no cap		
			@status = "available"
			@alert_class = "alert-success"
			@alert[0] = "This league is still open!"
			@alert[1] = "HURRY -"
			@alert[2] = "Last day to join and submit a #{board_type} is #{@league.draft_deadline.strftime("%D")}."
			@invite_button[0] = "Join This League"
			@invite_button[1] = join_path
			@invite_button[2] = "btn btn-sm btn-default"
			@invite_button[3] = "join"
			@invite_button[4] = @league.id
			@invite_button[5] = "POST"		
		when 	"np-unlocked-public-cap", "np-unlocked-private-cap"
			case cases[5]
			when :F1
				@status = "full"
				@alert_class = "alert-success"
				@alert[0] = "Sorry, this #{@league.type} league is currently full."
				@alert[1] = ""
				@invite_button[0] = nil
				@invite_button[1] = nil
				@invite_button[2] = nil	
			when :F2
				@status = "limited"
				@alert_class = "alert-danger"
				@alert[0] = "Only #{spots} #{"spot".pluralize(spots)} left in this league!"
				@alert[1] = ""
				@invite_button[0] = "Join This League"
				@invite_button[1] = join_path
				@invite_button[2] = "btn btn-sm btn-default"
				@invite_button[3] = "join"
				@invite_button[4] = @league.id
				@invite_button[5] = "POST"	
			else :F3 # all other cases
				@status = "available"
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

		# ============== ACTION BUTTONS =========== #
			@action_buttons = get_action_buttons(@league, @participants, @current_user, cases, board_type)

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
				# ============== ACTION BUTTONS =========== #
				@action_buttons = get_action_buttons(@league, @participants, @current_user, cases, board_type)

			end
			# sort roster to reflect current leads
			@participants_roster_total_sorted = @participants_roster_total.sort_by{|key, value| value}.reverse!
			
			deadline_alert = nil

			@league.rosters.where(user_id: @current_user.id).empty?

			deadline_alert = "Last day to submit a roster is on #{@league.draft_deadline.strftime('%B %d')}."

		end
	end

	def search
		public_leagues = League.includes(:users).where(public_access: true, active: true).order("created_at ASC")
		@pages = 1

		if params[:search].present?
			query = params[:search]
			@notice = "Search results for \"#{params[:search]}\""
			search_term = regex_validation(query)
			case search_term 
			when "empty"
				flash[:notice] = "Empty search query - please enter a search term."
				flash[:color] = "alert-warning"
				@league_results = nil
			when "league_key"
				@league_results = League.search_by_key(query)[0]
			else
				@league_results = League.where(public_access: true, active: true).order("created_at ASC")
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
			@league_results = public_leagues 
			@league_actions = Hash.new
			@league_results.each_with_index do |league, index|
				@league_actions[league.id] = {
					:path => league_path(league.id),
					:class => "btn btn-default btn-sm"
				}
				if league.users.include? @current_user
					if league.commissioner_id == @current_user.id
						@league_actions[league.id] = {
							:action => "Manage"
						}			
					else
						@league_actions[league.id] = {
							:action => "View"
						}						
					end
				else
					@league_actions[league.id] = {
						:action => "Join"
					}
				end
			end
			@private_leagues = League.where(:public_access => false) if @current_user.admin? 
		end

		if @league_results.count > 10
			@pages = @league_results.count / 10
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

	def get_action_buttons(league, participants_collection, current_user, current_user_cases, board_type)
		participants = participants_collection
		cases = current_user_cases

		button = []
		participants.each do |participant|
			button[participant.id] = []
			if cases[1] == "inactive"
				button[participant.id][0] = "View"
				button[participant.id][1] = ""
				button[participant.id][2] = "btn btn-default btn-sm"
			else
				if participant == current_user
					if cases[2] == "unlocked"
						if league.rounds.where(user_id: participant.id).empty?
							button[participant.id][0] = "Build #{league.type.capitalize} #{board_type.capitalize}"
							button[participant.id][1] = ""
							button[participant.id][2] = "btn btn-default btn-sm"
						end
						button[participant.id][0] = "View"
						button[participant.id][1] = ""
						button[participant.id][2] = "btn btn-default btn-sm"
					elsif cases[2] == "locked"	
						button[participant.id][0] = "View"
						button[participant.id][1] = ""
						button[participant.id][2] = "btn btn-default btn-sm"				
					else
						button[participant.id][0] = "View"
						button[participant.id][1] = ""
						button[participant.id][2] = "btn btn-default btn-sm"
					end
				end
			end		
		end
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
		if (@league.public_access? == false) && (@league.users.include? @current_user == false)
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
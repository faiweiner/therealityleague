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

		alert_package = get_alerts(@league, @participants)
		@status 				= alert_package[:status] 
		@alert_class 		= alert_package[:alert_class] 
		@alert 					= alert_package[:alert]
		@invite_button 	= alert_package[:invite_button]
		cases 					=  alert_package[:cases]

		data_package = get_rankings(@league, @league.type, cases)
		action_package = get_action_buttons(@current_user, @participants, @league, cases)
		@actions 				= action_package
		@rankings 			= data_package[:rankings]
		@headings 			= data_package[:headings]
		@weekly_scores 	= data_package[:weekly_scores]
		
		# bounce out of episodes dont exist yet
		if @rankings.nil? || @headings.nil? || @weekly_scores.nil?
			flash[:notice] = "This league is currently not ready for viewing."
			flash[:color] = "alert-warning"
			redirect_to :back
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

	def get_alerts(league, participants_collection)
		@league = league
		@show = @league.season.show
		data_package = Hash.new
		participants = participants_collection
		
		spots = nil
		board_type = ""
		board_count = 0

		case @league.type
		when "Fantasy"
			board_type = "roster"
			board_count = @league.rosters.count
			join_path = rosters_path(@league.id)
		when "Elimination"
			board_type = "bracket"
			board_count = @league.rounds.count
			join_path = rounds_create_path(@league.id)
		end

		if @league.participant_cap.present?
			spots = @league.participant_cap - participants.count
		end	

		@status = ""
		@alert_class = ""
		@alert = []
		@invite_button = []
		cases = []

		if participants.include? @current_user # index[0]
			if @league.commissioner_id == @current_user.id?
				cases[0] = "commissioner"
			else
				cases[0] = "participant"
			end
		else
			cases[0] = "non-participant"
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
		# A.4 ----- Argument Assignment ----- #
		
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
		# A.5 ----- Alert Values Assignment ----- #
		case argument
		when "all-locked"							 			# comm & p, active, LOCKED, public OR private (doesn't matter if there's a cap or not)
			@status = "locked"
			@alert_class = "alert-success"
			@alert[0] = "League Commenced"
			@alert[1] = "#{board_type.pluralize.capitalize} are locked and cannot be edited."
			@alert[2] = ""
			@invite_button[0] = nil
			@invite_button[1] = nil
			@invite_button[2] = nil			
		when "comm-unlocked-nocap" 					# comm, active, UNLOCKED, no cap, private OR public
			@status = "open"
			@alert_class = "alert-success"
			@alert[0] = "Open League"
			@alert[1] = "There's still plenty of space."
			@alert[2] = "#{board_type.pluralize.capitalize} can still be submitted."
			@invite_button[0] = "Invite Participants"
			@invite_button[1] = league_invite_path(@league.id)
			@invite_button[2] = "btn btn-sm btn-default"	
		when 	"comm-unlocked-cap" 						# comm, active, UNLOCKED, cap, private OR public
			case cases[5]
			when :F1 # spots == 0
				@status = "full"
				@alert_class = "alert-success"
				@alert[0] = "Full League"
				@alert[1] = ""
				@invite_button[0] = nil
				@invite_button[1] = nil
				@invite_button[2] = nil	
			when :F2 # spots less than 3
				@status = "limited"
				@alert_class = "alert-danger"
				@alert[0] = "Limited Space"
				@alert[1] = "Only #{spots} #{"spot".pluralize(spots)} left."
				@invite_button[0] = nil
				@invite_button[1] = nil
				@invite_button[2] = nil	
			else :F3 # all other cases
				@status = "available"
				@alert_class = "alert-warning"
				@alert[0] = "Open League"
				@alert[1] = "Invite friends to join the league before the league commences."
				@invite_button[0] = "Invite Participants"
				@invite_button[1] = league_invite_path(@league.id)
				@invite_button[2] = "btn btn-sm btn-default"			
			end	
		when 	"all-inactive"									# comm & p, inactive
			@status = "inactive"
			@alert_class = "warning"
			@alert[0] = "Inactive League"
			@alert[1] = "#{@show_title} has concluded."
			@alert[2] = "Would you like to revive this league for the next season of #{@league.season.show}?"
			@invite_button[0] = "Revive League"
			@invite_button[1] = "#"
			@invite_button[2] = "btn btn-sm btn-default"		
		when 	"p-locked" 										# p, active, LOCKED, public OR private (doesn't matter if there's a cap or not)
			@status = "locked"
			@alert_class = "alert-success"
			@alert[0] = "League commenced."
			@alert[1] = "#{board_type.pluralize.capitalize} are now locked and can no longer be edited."
			@alert[2] = "#{@show_title} premieres on #{@league.season.premiere_date.strftime("%m/%e")}."
			@invite_button[0] = nil
			@invite_button[1] = nil
			@invite_button[2] = nil		
		when 	"p-unlocked" 									# p, active, UNLOCKED, public OR private, cap OR no cap
			@status = "unlocked"
			@alert_class = "alert-warning"
			@alert[0] = "Have you finalized your #{board_type}?"
			@alert[1] = "Submit your #{board_type} before the league's deadline."
			@alert[2] = "#{@show_title} premieres on #{@league.season.premiere_date.strftime("%m/%e")}."
			@invite_button[0] = nil
			@invite_button[1] = nil
			@invite_button[2] = nil			
		when 	"np-unlocked-public-nocap",	"np-unlocked-private-nocap"		# p, active, UNLOCKED, public, no cap		
			@status = "available"
			@alert_class = "alert-success"
			@alert[0] = "Open League"
			@alert[1] = "There're still spots left."
			@alert[2] = "Last day to join and submit a #{board_type} is #{@league.draft_deadline.strftime("%m/%e")}."
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
				@alert[0] = "Full League"
				@alert[1] = "Sorry, there is no spot left."
				@invite_button[0] = nil
				@invite_button[1] = nil
				@invite_button[2] = nil	
			when :F2
				@status = "limited"
				@alert_class = "alert-danger"
				@alert[0] = "Limited Space"
				@alert[1] = "Only #{spots} #{"spot".pluralize(spots)} left in this league!"
				@invite_button[0] = "Join This League"
				@invite_button[1] = join_path
				@invite_button[2] = "btn btn-sm btn-default"
				@invite_button[3] = "join"
				@invite_button[4] = @league.id
				@invite_button[5] = "POST"	
			else :F3 # all other cases
				@status = "available"
				@alert_class = "warning"
				@alert[0] = "Almost Full!"
				@alert[1] = "Only #{spots} #{"spot".pluralize(spots)} left in this league."
				@alert[2] = "Last day to submit a #{board_type} is #{@league.draft_deadline.strftime("%m/%e")}."
				@invite_button[0] = "Join This League"
				@invite_button[1] = join_path
				@invite_button[2] = "btn btn-sm btn-default"
				@invite_button[3] = "join"
				@invite_button[4] = @league.id
				@invite_button[5] = "POST"		
			end	
		end

		data_package = {
			:status => @status,
			:alert_class => @alert_class,
			:alert => [@alert[0], @alert[1], @alert[2]],
			:invite_button => [@invite_button[0], @invite_button[1], @invite_button[2], @invite_button[3], @invite_button[4], @invite_button[5]],
			:cases => cases
		}	
	end

	def get_action_buttons(user, participants_collection, league, cases)
		current_user = user
		participants = participants_collection

		board_type = nil
		board_path = nil
		collection = nil

		case league.type
		when "Elimination"
			board_type = "bracket"
			board_path = "rounds/"
			collection = league.rounds.where(user_id: current_user.id)
		when "Fantasy"
			board_type = "roster"
			board_path = "rosters/"
			collection = league.rosters.where(user_id: current_user.id)
		end

		labels = ["View", "Pending", "Edit", "Build #{board_type.capitalize if board_type}", "Leave League"]
		button_classes = ["btn btn-default btn-sm", "btn btn-primary btn-sm", "btn btn-default btn-sm disabled"]

		buttons_options = Hash.new
		buttons_options[:self] = {
			:inactive => [labels[0], board_path, button_classes[1], "GET"],
			:locked => [labels[0], board_path, button_classes[1], "GET"],
			:editable => [labels[2], board_path, button_classes[1], "GET"],
			:unlocked => [labels[0], board_path, button_classes[1], "GET"],
			:empty => [labels[3], board_path, button_classes[1], "POST"]
		}
		buttons_options[:others] = {
			:inactive => [labels[0], board_path, button_classes[0]],
			:unlocked => [labels[1], board_path, button_classes[1]],
			:locked => [labels[0], board_path, button_classes[0]]
		}

		buttons_package = Hash.new
		participants.each do |participant|
			board_id = nil
			if league.type == "Elimination"
				board_id = league.rounds.where(user_id: participant.id).pluck(:id)[0]
			elsif league.type == "Fantasy"
				board_id = league.rosters.where(user_id: participant.id).pluck(:id)[0]
			end
			buttons_package[participant.username] = []
			final_button = nil

			if participant == current_user
				case cases[1]					# if active
				when "active"
					if cases[2] == "unlocked"	
						if collection.empty?	# if unlocked and bracket is empty - create
							buttons_options[:self][:empty][1] << "#{league.id}"
							buttons_package[participant.username] = buttons_options[:self][:empty]
						else									# if unlocked and can be viewed or edited
							buttons_options[:self][:unlocked][1] << "#{board_id}"
							buttons_package[participant.username][0] = buttons_options[:self][:unlocked]
							buttons_options[:self][:editable][1] << "#{board_id}/edit"
							buttons_package[participant.username][1] = buttons_options[:self][:editable]							
							buttons_options[:self][:unlocked][1] = board_path
							buttons_options[:self][:editable][1] = board_path
						end
					else										# if locked
						buttons_options[:self][:locked][1] << "#{board_id}"
						buttons_package[participant.username] = buttons_options[:self][:locked]
						buttons_options[:self][:locked][1] = board_path
					end
				when "inactive"
					buttons_options[:self][:inactive][1] << "#{board_id}"
					buttons_package[participant.username] = buttons_options[:self][:inactive]
					buttons_options[:self][:inactive][1] = board_path
				end
			# OTHER PPL
			else
				case cases[1]
				when "active"
					if cases[2] == "unlocked"
						buttons_options[:others][:unlocked][1] << "#{board_id}"
						buttons_package[participant.username] = buttons_options[:others][:unlocked]
						buttons_options[:others][:unlocked][1] = board_path
					elsif cases[2] == "locked"
						buttons_options[:others][:locked][1] << "#{board_id} h"
						buttons_package[participant.username] = buttons_options[:others][:locked]
						buttons_options[:others][:locked][1] = board_path
					end
				when "inactive"
					buttons_options[:others][:inactive][1] << "#{board_id}"
					buttons_package[participant.username] = buttons_options[:others][:inactive]
					buttons_options[:others][:inactive][1] = board_path
				end
			end
		end

		return buttons_package
	end

	def get_rankings(league, type, cases)
		participants = league.users.order(username: :desc)
		episodes_expected = league.season.episode_count
		episodes_collection = league.season.episodes
		headings = []
		rankings = Hash.new
		actions = Hash.new
		boards_collection = Hash.new
		user_board_collection = Hash.new
		weekly_scores = Hash.new
		data_package = Hash.new
		
		if episodes_collection.count != episodes_expected
			data_package = {
				:rankings => nil,
				:headings => nil,
				:actions => nil,
				:weekly_scores => nil
			}
			return data_package
		end

		headings.push("Participant")
		episodes_collection.length.to_i.times {|count| headings.push("#{count+1}")}
		headings.push("Total")
		
		participants.each_with_index do |participant, i|
			boards_collection[participant.username] = []
			user_board_collection[participant.id] = []
			case type
			when "Elimination"
				if participant == @current_user  
					user_board_collection[participant.id] = league.rounds.where(user_id: participant.id)
				end		
				user_board_collection = league.rounds.where(user_id: participant.id) 	# get collection of rounds
				score = participant.calculate_total_rounds_points(league)							# get score for league
				episodes_collection.each_with_index do |episode, i|
					points = user_board_collection[i].calculate_round_points
					if points == 0 && episode.aired? == false
						boards_collection[participant.username][i] = "--"
					else  
						boards_collection[participant.username][i] = points
					end
				end
			when "Fantasy"
				if participant == @current_user  
					user_board_collection[participant.id] = league.rosters.where(user_id: participant.id)
				end	
				roster = league.rosters.where(user_id: participant.id)[0] # get roster in collection form
				if roster.present?
					contestants_collection = roster.contestants
					score = roster.calculate_total_roster_points
					episodes_collection.each_with_index do |episode, i|
						points = 0
						contestants_collection.each do |contestant|
							points += contestant.calculate_points_per_episode(episode.id)
						end
						if points == 0 && episode.aired? == false
							boards_collection[participant.username][i] = "--"
						else  
							boards_collection[participant.username][i] = points
						end
					end
				else
					boards_collection[participant.username][i] = "--"
					score = 0
				end
			end
			boards_collection[participant.username].push(score)
			rankings[participant.username] = {:total_score => score}
		end		
		rankings_sorted = rankings.map.sort_by {|k, v| -v[:total_score]}
		boards_sorted = boards_collection.map.sort_by {|k, v| k}
		data_package = {
			:rankings => rankings_sorted,
			:headings => headings,
			:weekly_scores => boards_sorted
		}
	end

	def calculate_elimination_league_ranking(league_rounds_collection)
		@rounds_collection = league_rounds_collection
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
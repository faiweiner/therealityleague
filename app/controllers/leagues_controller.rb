class LeaguesController < ApplicationController

	before_action :check_if_logged_in, :except => [:index, :new]
	skip_before_action :verify_authenticity_token, :only => [:results]
	before_action :save_login_state, :only => [:new, :search, :results]
	before_action :get_league, :only => [:edit, :invite]
	before_action :private_restriction, :only => [:display]
	before_action :commissioner_restriction?, :only => [:edit]

	attr_accessor :name, :league_key, :league_password
	
	def index
		if @current_user == nil
			flash[:notice] = "You must be a registered user to view leagues. Please sign up or sign in."
			flash[:color] = "invalid"
			redirect_to new_user_path
		end		

		# List of all leagues for full app's admin
		@all_leagues = League.all

		if @current_user.present?
			# List of participating leagues
			@leagues = @current_user.leagues.where(:active => true)
			@past_leagues = @current_user.leagues.where(:active => false)
			if @past_leagues.nil?
				flash[:notice] = "You have yet to compete in a league."
			end
			
			# List of leagues of which user is the commissioner
			@comm_leagues = League.where(commissioner_id: @current_user.id)
			# @league_players = @league.users
			@all_leagues = @current_user.leagues
			# Get user's roster for that particular league
			@rosters = @current_user.rosters
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
			flash[:color] = "valid"
			
			redirect_to league_path(@league.id)
		else
			flash[:notice] = "Something went wrong and we were unable to save your league"
			flash[:color] = "invalid"
			render :new
		end
		
	end

	def edit
		if commissioner_restriction? == false
			flash[:notice] = "This account is not authorized to edit the current league."
			flash[:color] = "prohibited"
			redirect_to league_path(params[:id])
		end
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
		@league = League.find params[:id]
		@league.destroy
		redirect_to leagues_path
	end

	def display
		@participants = @league.users
		@show = @league.season.show
		@rules = Show.get_schemes(@show.id)
		@a_participant = nil
		p_id = @participants.pluck(:id)
		
		if p_id.include? @current_user.id
			@a_participant = true
		else
			@a_participant = false
		end
		
		if @league.draft_deadline
			@league_deadline_set = true
			@league_commenced = true if @league.draft_deadline <= Date.today
		else
			@league_deadline_set = false
		end

		@comm_this_league = true if @league.commissioner_id == @current_user.id

		case @league.type

		# ========== FOR ELIMINATION ========== #
		when "Elimination"
			@participants_ranking = {}
			@participants.each_with_index do |participant, i|
				@participants_ranking[i] = {
					:participant => participant,
					:score => participant.calculate_total_rounds_points(@league)
				}
			end
			@ranking = @participants_ranking.map.sort_by{|k, v| -v[:score]}

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
			
		end

		

		respond_to do |format|
			format.html
			format.js { 		
				render :json => {
					:leagueId => @league.id,
					:exportParticipants => @participants
				} 
			}
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

	def get_league
		@league = League.includes(:users, :season).find(params[:id]).becomes(League)
	end

	def private_restriction
		@league = League.find(params[:id])
		if @league.public_access == false
			if @league.users.include? @current_user == false
				flash[:notice] = "You do not have permission to access this private league."
				flash[:color] = "prohibited"
				redirect_to leagues_path
			end
		end
	end

	def commissioner_restriction?
		@league = League.find(params[:id])
		if @current_user.id == @league.commissioner_id
			return true
		else
			return false
		end
	end
end
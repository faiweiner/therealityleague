class LeaguesController < ApplicationController

	before_action :check_if_logged_in, :except => [:index, :new]
	skip_before_action :verify_authenticity_token, :only => [:results]
	before_action :save_login_state, :only => [:new, :search, :results]
	before_action :private_restriction, :only => [:display]
	before_action :commissioner_restriction?, :only => [:edit]

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
		
		@type = [["Fantasy", "Fantasy"],["Bracket", "Bracket"]]
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
		@league = League.includes(:season).find(params[:id]).becomes(League)
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
		@rules_survival = Show.get_schemes(@show.id, "Survival")
		@rules_game = Show.get_schemes(@show.id, "Game")
		@rules_extra =Show.get_schemes(@show.id, "Extracurricular")
		@league_type = @league.type
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

		# assign hashes
		@participants_roster_id = {}
		@participants_roster_total = {}
		@participants_roster_weekly = {}

		case @league_type

		# FOR BRACKETS ROSTERS ---- assign values to hashes --- 
		when "Bracket"
			@participants.each do |participant|
				# get Roster ID
				roster_id = participant.rosters.where(league_id: @league.id).pluck(:id)[0]
				@participants_roster_id.store(participant.username, roster_id)

				# get Rounds Total
				roster_rounds_total = Roster.find(roster_id).calculate_total_rounds_points
				@participants_roster_total.store(participant.username, roster_rounds_total)

				# get Rounds Weekly
				roster_rounds_points = []
				roster_rounds = Roster.find(roster_id).rounds.pluck(:id)		# stores hash of { round_id => points }
				roster_rounds.each do |id| 
					round = Round.find(id)
					roster_rounds_points << [id, round.calculate_round_points]
				end
				@participants_roster_weekly.store(participant.username, {roster_rounds_id: roster_rounds_points})
			end
		
			# sort roster to reflect current leads
			@participants_roster_total_sorted = @participants_roster_total.sort_by{|key, value| value}.reverse!

		# FOR FANTASY ROSTERS ---- assign values to hashes --- 
		when "Fantasy"
			@participants.each do |participant|
				# get Roster ID
				roster_id = participant.rosters.where(league_id: @league.id).pluck(:id)[0]
				@participants_roster_id.store(participant.username, roster_id)
				# get Roster Total
				roster_total = Roster.find(roster_id).calculate_total_roster_points
				@participants_roster_total.store(participant.username, roster_total)

				# get Roster Rounds
				roster_rounds_points = []
				roster_rounds = Roster.find(roster_id).rounds.pluck(:id)		# stores hash of { round_id => points }
				roster_rounds.each do |id| 
					round = Round.find(id)
					roster_rounds_points << [id, round.calculate_round_points]
				end
				@participants_roster_weekly.store(participant.username, {roster_rounds_id: roster_rounds_points})
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
		@league = League.find params[:id]
	end

	def access
		if params[:league_key].empty? || params[:password].empty?
			flash[:notice] = "Private league key and password empty. Please try again."
			flash[:color] = "invalid"
			redirect_to leagues_search_path
		end

		if League.where(league_key: params[:league_key]).first.present?
			@league = League.where(league_key: params[:league_key]).first
		end

		if @league.present? && @league.league_password === params[:password]
			params[:league] = @league.id
			redirect_to	league_path(@league.id)
		else
			flash[:notice] = "Invalid league key and password. Please try again."
			flash[:color] = "invalid"
			redirect_to leagues_search_path
		end
	end

	private

	# standard strong params practice
	def league_params
		params.require(:league).permit(:name, :commissioner_id, :season_id, :public_access, :type, :scoring_system, :league_key, :league_password, :active, :draft_deadline, :draft_limit)
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
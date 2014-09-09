class LeaguesController < ApplicationController

	before_action :check_if_logged_in, :except => [:index, :new, :search]
	before_action :save_login_state, :only => [:new, :search]

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
		if @current_user == nil
			flash[:notice] = "Looks like you haven't registered yet - please sign up before creating a new league."
			flash[:color] = "invalid"
			redirect_to new_user_path
		end
		@draft_type = [["Select draft type", nil],["Fantasy", "Fantasy"],["Bracket", "Bracket"]]
		@league = League.new 
	end
	
	def create
		@league = League.new league_params
		@league.season_id = params[:league][:season]
		season = Show.where(name: params[:league][:season])
		
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
		@league = League.find(params[:id])
		@league_season_id = @league.season_id
		@league_draft_type = @league.draft_type
		@draft_type = [["Select draft type", nil],["Fantasy", "Fantasy"],["Bracket", "Bracket"]]		
	end

	def update
		@league = League.find(params[:id])
		@league.update league_params
		redirect_to leagues_path
	end

	def destroy
		@league = League.find params[:id]
		@league.destroy
		redirect_to leagues_path
	end
	def show
		@league = League.find(params[:id])
		@league_type = @league.draft_type
		@league_season = Season.find(@league.season)
		# @league_rosters = @league.rosters
		@participants = @league.users
		@a_participant = nil
		p_id = @participants.pluck(:id)
		@comm_this_league = true if @league.commissioner_id == @current_user.id
		if p_id.include? @current_user.id
			@a_participant = true
		else
			@a_participant = false
		end
	
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
			
		
		# IF NO ROSTER TYPE ASSIGNED
		else
			raise "need to fix this"
		end
	end

	def search
		@public_leagues = League.where(:public_access => true).order("created_at DESC") # FIXME!
		@private_leagues = League.where(:public_access => false)
	end

	def results
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

	def join
		@league = League.find(params[:league])
		@league.users << @current_user
		if Roster.where(user_id: @current_user.id).where(league_id: @league.id).nil?
			roster = Roster.create(user_id: @current_user.id, league_id: @league.id)
			roster.save
		else
			flash[:notice] = "You already have a roster for this league."
			flash[:color] = "invalid"
			redirect_to league_path(@league.id)
		end
	end

	private

	def league_params
		params.require(:league).permit(:name, :commissioner_id, :show_id, :public_access, :draft_type, :league_key, :league_password, :active)
	end

	def get_id(username)
		user = User.where(username: username).first
		return user.id
	end

end
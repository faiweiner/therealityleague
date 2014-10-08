class RostersController < ApplicationController
	before_action :check_if_logged_in
	before_action :save_login_state

	def index
		if @current_user== nil
			flash[:notice] = "You must be a registered user to explore the site. Please sign up or sign in."
			flash[:color] = "invalid"
			redirect_to new_user_path	
		elsif @current_user.rosters.count == 0
			flash[:notice] = "You must be a league member to have a roster. Please join a league."
			flash[:color] = "invalid"	
			redirect_to root_path
		end	
	end

	def create
		league = League.find(params[:league_id])
		Roster.find_or_create_by!(:user_id => @current_user.id, :league_id => league.id)
		league.users << @current_user
		redirect_to league_path(league.id)
	end

	def edit
		@roster = Roster.includes(:league).find(params[:id])
		@roster.league.draft_limit
		@all_contestants = Contestant.where(season_id: @roster.league.season).order(name: :asc)
		@selected_contestants = @roster.contestants.order(name: :asc)
		@available_contestants = []
		# iterate to pull list of non-selected contestants
		@all_contestants.select do |contestant|
			unless @selected_contestants.include? contestant
				@available_contestants.push contestant
			end
		end
	end

	def show
		@roster = Roster.find(params[:id])
		@all_contestants = Contestant.where(season_id: @roster.league.season).order(name: :asc)
		@selected_contestants = @roster.contestants.order(name: :asc)
		@available_contestants = []
		# iterate to pull list of non-selected contestants
		@all_contestants.select do |contestant|
			unless @selected_contestants.include? contestant
				@available_contestants.push contestant
			end
		end
		@available_contestants.sort
	end

	def destroy
		@roster = Roster.includes(:league).find(params[:id])
		league = @roster.league
		if @roster.league.draft_deadline && @roster.league.draft_deadline.past?
			flash[:notice] = "You cannot leave a commenced league."
			flash[:color] = "invalid"
			redirect_to league_path(league.id)
		elsif @roster.user.id == league.commissioner_id
			flash[:notice] = "A commissioner cannot leave the league."
			flash[:color] = "invalid"
			redirect_to league_path(league.id)			
		else
			@roster.destroy
			league.users.destroy(User.find(@current_user.id))
			flash[:notice] = "You've successfully left league '#{@roster.league.name}'."
			flash[:color] = "valid"
			redirect_to leagues_path
		end
	end

	# ============ ADD/REMOVE CONTESTANTS FROM ROSTER ============ #

	def add
		# adding contestants to rosters, because when you join a league, a roster is automatically created 
		@roster = Roster.includes(:league, :contestants).find(params[:roster_id])
		contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id] != nil
		limit = @roster.league.draft_limit
		if limit && @roster.contestants.count + 1 <= limit
			@roster.contestants << contestant unless @roster.contestants.include? contestant
		else
			# @roster.contestants << contestant unless @roster.contestants.include? contestant
		end
		# i.e. do NOT append if roster already includes contestant
		@selected_contestants = @roster.contestants.order(name: :asc)
		respond_to do |format|
			format.html { render :partial => "current_roster" }
			format.js {
				render :json => { :contestantsCount => @selected_contestants.count, :leagueLimit => @roster.league.draft_limit }
			}
		end
	end

	def remove
		# removing contestants from rosters
		@roster = Roster.includes(:contestants).find(params[:roster_id])

		if params[:contestant_id]
			contestant = Contestant.find(params[:contestant_id])
			@roster.contestants.destroy(contestant)
		end

		all_contestants = Contestant.where(season_id: @roster.league.season).order(name: :asc)
		@available_contestants = []
		all_contestants.select do |contestant|
			unless @roster.contestants.include? contestant
				@available_contestants.push contestant
			end
		end
		render :partial => "current_available_contestants"
	end

	# ======== rendering for roster edit page ======== #
	def current
		@roster = Roster.includes(:league, :contestants).find(params[:roster_id])
		@selected_contestants = @roster.contestants.order(name: :asc)
		@contestantsCount = @selected_contestants.count
		respond_to do |format|
			format.html { render :partial => "current_roster" }
			format.js {
				render :json => { :contestantsCount => @selected_contestants.count, :leagueLimit => @roster.league.draft_limit }
			}
		end
		
	end

	def available
		@roster = Roster.includes(:contestants).find(params[:roster_id])
		all_contestants = Contestant.where(season_id: @roster.league.season).order(name: :asc)
		@available_contestants = []
		all_contestants.select do |contestant|
			unless @roster.contestants.include? contestant
				@available_contestants.push contestant
			end
		end
		@available_contestants
		respond_to do |format|
			format.html { render :partial => "current_available_contestants" }
			format.js {
				render :json => {}
			}
		end
	end
	# ===========

	private

	def roster_params
		params.require(:roster).permit(:user_id, :league_id)
	end
end


# post to the server, change this contestant to become selected, remove it fromthe front end

# also render the actual contestant back BECCAUSE in AJAX function you'll get data back from the server and you can use that to build the new element that you need to append to the right handside

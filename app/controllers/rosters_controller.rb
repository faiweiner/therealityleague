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
		@league = @roster.league
		@season = @league.season
		@contestants = @season.contestants.order(name: :asc)
		@selected_contestants = @roster.contestants.order(name: :asc)	

		roster_action = "landing"
		count_difference = @roster.contestants.count - @league.draft_limit
		@roster_status = ""

		if count_difference == 0
			@roster_status = "alert-success"
		elsif count_difference > 0
			@roster_status = "alert-danger"
		else
			@roster_status = "alert-warning"
		end

		@roster_message = Hash.new
		@roster_message = get_roster_messsage(@roster_status, count_difference, roster_action)
	end

	def display
		@roster = Roster.includes(:league, :contestants).find(params[:id])
		@league = @roster.league
		@season = Season.includes(:contestants, :episodes).find(@league.season_id)
		@show = @season.show

		case @league.type
		when "Fantasy"
			@episodes = @season.episodes
			@eps_record = @season.episode_count
			@eps_count = @season.episodes.count
			@eps_left = @eps_record - @eps_count
			@contestants = @roster.contestants.order(name: :asc)
		when "Bracket"
			@contestants_rounds = []
			@rounds.each_with_index do |round, index|
				round = {
					:round => (index + 1),
					:contestants => [
						round.contestants.map.each_with_index do |c,i| 
							{ :name => c.name, 
								:id => c.id, 
								:points_round => c.calculate_points_per_round(round.id)
							}
						end
					],
					:points_total => round.calculate_round_points
				}
				@contestants_rounds.push round
			end
		end

		if @league.active?
			@all_contestants = @season.contestants
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

		respond_to do |format|
			format.html
			format.js {
				render :json => {
					:contestantsRounds => @contestants_rounds
				}
			}
		end
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

	# ============ ADD/REMOVE CONTESTANTS FROM FANTASY ROSTER ============ #

	def add
		# adding contestants to rosters, because when you join a league, a roster is automatically created 
		@roster = Roster.includes(:league, :contestants).find(params[:roster_id])
		@league = @roster.league
		contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id] != nil

		@season = @league.season
		@contestants = @season.contestants.order(name: :asc)
		@selected_contestants = @roster.contestants.order(name: :asc)
		
		@roster_status = ""
		roster_action = "add"
		count_difference = 0

		# go through this process if there is a draft limit
		if @league.draft_limit.present?

			# check if adding to the roster will go over the limit
			unless @roster.contestants.count + 1 > @league.draft_limit
				@roster.contestants << contestant unless @roster.contestants.include? contestant
				count_difference = (@roster.contestants.count - @league.draft_limit).abs
				
				case count_difference	== 0
				when true
					@roster_status = "alert-success"
				when false
					@roster_status = "alert-warning"
				end
			# cannot add if you've already met the limit
			else
				@roster_status = "alert-warning"
				roster_action = "overadd"
			end
		
		# for special leagues with no draft limit
		elsif @league.draft_limit.nil? 
			@roster.contestants << contestant unless @roster.contestants.include? contestant
			@roster_status = "alert-success"
			roster_action = "add"
		end

		@roster_message = Hash.new
		@roster_message = get_roster_messsage(@roster_status, count_difference, roster_action)

		respond_to do |format|
			format.html { 
				render partial: "current_roster", :remote => true 
			}
			format.json {
				render :json => {
					:contestants => @contestants
				}
			}
		end
	end

	def remove
		# removing contestants from rosters
		@roster = Roster.includes(:contestants).find(params[:roster_id])
		@league = @roster.league
		@season = @league.season	

		contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id] != nil		
		@roster.contestants.destroy(contestant)

		@contestants = Contestant.where(season_id: @season.id).order(name: :asc)
		@selected_contestants = @roster.contestants.order(name: :asc)

		@roster_status = ""
		roster_action = "remove"
		count_difference = @roster.contestants.count - @league.draft_limit

		case count_difference == 0
		when true
			@roster_status = "alert-success"
		when false
			if count_difference > 0
				@roster_status = "alert-danger"
			else
				@roster_status = "alert-warning"
			end
		end
			
		@roster_message = Hash.new
		@roster_message = get_roster_messsage(@roster_status, count_difference, roster_action)

		respond_to do |format|
			format.html { 
				render partial: "current_roster", :remote => true 
			}
		end
	end

	# ======== rendering CONTESTANTS for roster edit page ======== #
	
	def current
		@roster = Roster.includes(:league, :contestants).find(params[:roster_id])
		@league = @roster.league
		@season = @league.season
		@contestants = Contestant.where(season_id: @league.season.id).order(name: :asc)
		@selected_contestants = @roster.contestants.order(name: :asc)
		@contestantsCount = @selected_contestants.count
		respond_to do |format|
			format.html { render :partial => "rosters/current_roster" }
			format.js {
				render :json => { :contestantsCount => @selected_contestants.count, :leagueLimit => @roster.league.draft_limit }
			}
		end
		
	end

	# def available
	# 	@roster = Roster.includes(:contestants).find(params[:roster_id])
	# 	all_contestants = Contestant.where(season_id: @roster.league.season).order(name: :asc)
	# 	@available_contestants = []
	# 	all_contestants.select do |contestant|
	# 		unless @roster.contestants.include? contestant
	# 			@available_contestants.push contestant
	# 		end
	# 	end
	# 	@available_contestants
	# 	respond_to do |format|
	# 		format.html { render :partial => "current_available_contestants" }
	# 		format.js {
	# 			render :json => {}
	# 		}
	# 	end
	# end
	# ===========

	private

	def roster_params
		params.require(:roster).permit(:user_id, :league_id)
	end

	def get_roster_messsage(status, count_difference, action)
		@roster_message = Hash.new

		case status
		when "alert-success"
			@roster_message = {
				:contentHero => "Your roster has been completed!",
				:contentSupport => {
					:a => "You can make changes to the roster until the league's draft deadline on",
					:b => ""
				},
				:contentCountDifference => nil,
				:contentDate => nil
			}
		when "alert-warning"
			if action == "add"
				@roster_message = {
					:contentHero => "There's still room in your roster.",
					:contentSupport => {
						:a => "Add",
						:b => "to complete your roster."
					},
					:contentCountDifference => count_difference,
					:contentDate => nil
				}
			elsif action == "overadd"
				@roster_message = {
					:contentHero => "You don't have enough room to add another contestant!",
					:contentSupport => {
						:a => "Please remove a contestant from your current roster before adding a new one.",
						:b => ""
					},
					:contentCountDifference => nil,
					:contentDate => nil
				}
			else action == "landing"
				@roster_message = {
					:contentHero => "Pick your contestants!",
					:contentSupport => {
						:a => "Add",
						:b => "to your roster before the league's draft deadline on"
					},
					:contentCountDifference => count_difference.abs,
					:contentDate => "#{@league.draft_deadline.strftime("%D")}."
				}				
			end
		when "alert-danger"
			@roster_message = {
				:contentHero => "You have too many contestants in your roster!",
				:contentSupport => {
					:a => "Remove",
					:b => "to complete your roster."
				},
				:contentCountDifference => count_difference,
				:contentDate => nil
			}		
		else
		end
	end
end


# post to the server, change this contestant to become selected, remove it fromthe front end

# also render the actual contestant back BECCAUSE in AJAX function you'll get data back from the server and you can use that to build the new element that you need to append to the right handside

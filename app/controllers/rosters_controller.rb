class RostersController < ApplicationController
	before_action :check_if_logged_in
	# before_action :save_login_state, :only => [:new, :create]

	def index
		if @current_user == nil
			flash[:notice] = "You must be a registered user to explore the site. Please sign up or sign in."
			flash[:color] = 'invalid'
			redirect_to new_user_path	
		end	
	end

	def add
		# adding contestants to rosters, because when you join a league, a roster is automatically created 
		@roster = Roster.find(params[:roster_id])
		contestant = Contestant.find(params[:contestant_id])
		unless @roster.contestants.include? contestant
			@roster.contestants << contestant
		end
		@selected_contestants = @roster.contestants
		render :partial => "current_roster"
	end

	def remove
		# removing contestants from rosters
		@roster = Roster.find(params[:roster_id])
		@roster.contestants.find(:contestant_id).destroy
		render :partial => "current_roster"
	end
	
	def edit
		@roster = Roster.find(params[:id])
		@all_contestants = Contestant.where(show_id: @roster.league.show)
		@selected_contestants = @roster.contestants
		@available_contestants = []
		# iterate to pull list of non-selected contestants
		@all_contestants.select do |contestant|
			unless @selected_contestants.include? contestant
				@available_contestants.push contestant
			end
		end
	end

	def create
		
	end
	
	def show
		@roster = Roster.find(params[:id])
		@all_contestants = Contestant.where(show_id: @roster.league.show)
		@selected_contestants = @roster.contestants
		@available_contestants = []
		# iterate to pull list of non-selected contestants
		@all_contestants.select do |contestant|
			unless @selected_contestants.include? contestant
				@available_contestants.push contestant
			end
		end
	end

end


# post to the server, change this contestant to become selected, remove it fromthe front end

# also render the actual contestant back BECCAUSE in AJAX function you'll get data back from the server and you can use that to build the new element that you need to append to the right handside

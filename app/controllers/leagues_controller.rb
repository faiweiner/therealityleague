class LeaguesController < ApplicationController

	def index
		# List of all leagues for full app's admin
		@all_leagues = League.all

		# List of participating leagues
		@leagues = @current_user.leagues

		# List of leagues of which user is the commissioner
		@comm_leagues = League.where(commissioner_id: @current_user.id)
		@comm_leagues_name_array = []
		@comm_leagues.each do |league|
			@comm_leagues_name_array << league.name
		end
		# @league_players = @league.users
		@all_leagues = @current_user.leagues

		raise "HELL COME BACK TO THIS"
	end
	def new
		@league = League.new 
	end

	def create
		@league = League.new league_params
		@league.show_id = params[:league][:show]
		show = Show.where(name: params[:league][:show])
		
		if @league.save
			# Automatically adds the commissioner (user) as participant of the league
			@league.users << [@current_user]

			# get customized text based on type
			@access_type = nil
			if @league.public_access == true
				@access_type = 'public'
			else
				@access_type = 'private'
			end
			flash[:notice] = "You\'ve successfully created a #{@access_type} league!"
			# Once someone signs up, they currently need to log in. Better to have automatically log-in?
			flash[:color] = 'valid'
			redirect_to league_path(League.last)
		else
			flash[:notice] = 'Something went wrong and we were unable to save your league'
			flash[:color] = 'invalid'
			render :new
		end
	end

	def show
		@league = League.last
	end
	def search
		@public_leagues = League.where(:public_access => true)
	end

	def results
	end

	private

	def league_params
    params.require(:league).permit(:name, :commissioner_id, :show_id, :public_access, :draft_type, :scoring_system, :league_key, :league_password)
  end

end

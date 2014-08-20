class LeaguesController < ApplicationController

	before_action :check_if_logged_in, :except => [:index, :new, :create, :search]
	before_action :save_login_state, :only => [:new, :create]

	def index
		if @current_user == nil
			flash[:notice] = "You must be a registered user to view leagues. Please sign up or sign in."
			flash[:color] = 'invalid'
			redirect_to new_user_path
		end		

		# List of all leagues for full app's admin
		@all_leagues = League.all

		if @current_user.present?
			# List of participating leagues
			@leagues = @current_user.leagues
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
			flash[:color] = 'invalid'
			redirect_to new_user_path
		end

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
		@league = League.find(params[:id])
		@league_show = Show.find(@league.show)
		@participants = @league.users
		@comm_this_league = true if @league.commissioner_id == @current_user.id
		@not_a_participant = true if @participants.include? @current_user == false
	end

	def search
		@public_leagues = League.where(:public_access => true).order("created_at DESC") # FIXME!
		@private_leagues = League.where(:public_access => false)
	end

	def results
	end

	private

	def league_params
    params.require(:league).permit(:name, :commissioner_id, :show_id, :public_access, :draft_type, :scoring_system, :league_key, :league_password)
  end

end

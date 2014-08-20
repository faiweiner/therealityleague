class RostersController < ApplicationController
	# before_action :check_if_logged_in, :except => [:index, :new, :create]
	# before_action :save_login_state, :only => [:new, :create]

	def index
		if @current_user == nil
			flash[:notice] = "You must be a registered user to explore the site. Please sign up or sign in."
			flash[:color] = 'invalid'
			redirect_to new_user_path	
		end	

	end

	def edit
		@roster = Roster.find params[:id]
		@selected_contestants = @roster.contestants
  	render :json => @selected_contestants
	end
	
	def show
		@roster = Roster.find(params[:id])
		@all_contestants = Contestant.where(show_id: @roster.league.show)
		@selected_contestants = @roster.contestants
	end
end

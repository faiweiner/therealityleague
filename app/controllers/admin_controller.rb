class AdminController < ApplicationController
	layout "admin"
	
	def home
		if @current_user.admin?
			confirm_admin
		else
			redirect_to root_path
		end
		@users = User.all
		@shows = Show.all
		@leagues = League.all
	end

	def show
		@shows = Show.all	
	end

	private

	def confirm_admin
		@raise = "you are an admin!"
	end
end
class AdminController < ApplicationController

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

	private

	def confirm_admin
		@raise = "you are an admin!"
	end
end
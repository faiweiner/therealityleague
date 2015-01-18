class AdminController < ApplicationController
	layout "admin"
	before_action :check_if_admin
	
	def home
		@users = User.all
		@shows = Show.all
		@leagues = League.all
	end

	def show
		@shows = Show.all	
	end

	def seasons
		@current_seasons = Season.where(expired: false)		
		@past_seasons = Season.where(expired: true)
	end

	private

	def check_if_admin
		if @current_user.nil? || @current_user.admin? == false
			flash[:notice] = "You are not authorized to access the administrative page."
			flash[:color] = "alert-danger"
			redirect_to root_path
		end
	end
end
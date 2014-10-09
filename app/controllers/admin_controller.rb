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

	def confirm_admin
		@raise = "you are an admin!"
	end
end
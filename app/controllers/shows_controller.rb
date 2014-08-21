class ShowsController < ApplicationController
	def index
		@shows = Show.where(:expired => :false).order("premiere_date ASC")
		@past_shows = Show.where(:expired => :true).order("premiere_date DESC")
	end
	def show
		@show = Show.find(params[:id])
		@contestants = @show.contestants
		# raise
	end
end
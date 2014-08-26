class ShowsController < ApplicationController
	def index
		@shows = Show.where(:expired => :false).order("premiere_date ASC")
		@past_shows = Show.where(:expired => :true).order("premiere_date DESC")
		@current_date = DateTime.now.strftime("%B %d, %Y")

	end

	def new
		@shows = Show.all
	end

	def edit
		@show = Show.find(params[:id])
	end

	def show
		@show = Show.find(params[:id])
		@contestants = @show.contestants
		# raise
	end
end
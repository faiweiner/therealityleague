class ShowsController < ApplicationController
	def index
		@shows = Show.all.where(:expired => :false).order("premiere_date ASC")
	end
	def show
		@show = Show.find(params[:id])
		@contestants = @show.contestants
		# raise
	end
end
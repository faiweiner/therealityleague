class ShowsController < ApplicationController
	def index
		@shows = Show.all.order("name ASC")
	end
	def show
		@show = Show.find(params[:id])
		@contestants = @show.contestants
		# raise
	end
end
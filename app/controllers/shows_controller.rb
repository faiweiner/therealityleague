class ShowsController < ApplicationController
	def show
		@show = Show.find(params[:id])
	end
end
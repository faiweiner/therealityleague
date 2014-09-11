class ShowsController < ApplicationController
	def index
		
	end

	def new
		@show = Show.new
	end

	def create
		
	end

	def show
		@show = Show.find(params[:id])
		@rules_survival = @show.events.where(type: "Survival")
		@rules_game = @show.events.where(type: "Game")
		@rules_extra = @show.events.where(type: "Extracurricular")
	end

	def edit
		
	end
end
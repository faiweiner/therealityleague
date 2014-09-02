class ShowsController < ApplicationController
	def show
		@show = Show.find(params[:id])
		@rules_survival = @show.events.where(type: "Survival")
		@rules_game = @show.events.where(type: "Game")
		@rules_extra = @show.events.where(type: "Extracurricular")
	end
end
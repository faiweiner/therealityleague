class ShowsController < ApplicationController
	before_action :check_if_admin, :only => [:new, :create, :edit, :update, :destroy]
	def index
		@shows = Show.all
	end

	def new
		@show = Show.new
	end

	def create
		
	end

	def show
		@show = Show.find(params[:id])
		@rules_survival = @show.schemes.where(type: "Survival")
		@rules_game = @show.schemes.where(type: "Game")
		@rules_extra = @show.schemes.where(type: "Extracurricular")
	end

	def edit
		
	end
end
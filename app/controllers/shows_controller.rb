class ShowsController < ApplicationController
	before_action :check_if_admin, :only => [:new, :create, :edit, :update, :destroy]
	def index
		@shows = Show.all
	end

	def new
		@show = Show.new
	end

	def create
		@show = Show.new show_params
		if @show.save
			redirect_to show_path(@show.id)
		else
			render :new
		end
	end

	def display
		Show.get_schemes(params[:id])
		@show = Show.find(params[:id])
		@rules_survival = @show.schemes.where(type: "Survival")
		@rules_game = @show.schemes.where(type: "Game")
		@rules_extra = @show.schemes.where(type: "Extracurricular")
	end

	def edit
		@show = Show.find(params[:id])
	end

	def update
		@show = Show.find(params[:id])
		@show.update show_params
		redirect_to show_path(@show.id)
	end

	private
	def show_params
		params.require(:show).permit(:name, :image)
	end
end
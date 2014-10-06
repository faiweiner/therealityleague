class ShowsController < ApplicationController
	before_action :check_if_admin, :only => [:new, :create, :edit, :update, :destroy]
	around_action :render_admin, :only => [:index]
	
	def index
		@shows = Show.all
	end

	def new
		@show = Show.new
		render_admin
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
		@show = Show.find(params[:id])
		@rules_survival = Show.get_schemes(@show.id, "Survival")
		@rules_game = Show.get_schemes(@show.id, "Game")
		@rules_extra =Show.get_schemes(@show.id, "Extracurricular")
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
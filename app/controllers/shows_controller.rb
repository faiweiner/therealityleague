class ShowsController < ApplicationController
	before_action :check_if_admin, only: [:new, :create, :edit, :update, :destroy]
	layout "admin", except: [:index, :display]

	def index
		@shows = Show.includes(:seasons).all
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
		@show = Show.includes(:seasons).find(params[:id])
		@seasons = @show.seasons
		@rules = Show.get_schemes(@show.id)
		render_admin
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
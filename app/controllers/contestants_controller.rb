class ContestantsController < ApplicationController
	before_action :check_if_admin
	layout "admin"

	def index
		@season = Season.includes(:contestants).find(params[:season_id])
		@contestant = Contestant.new
		@contestants = @season.contestants
	end

	def edit_single
		@contestant = Contestant.find(params[:contestant_id])
	end

	def update
		@contestant = Contestant.find(params[:id])
		@contestant.update contestant_limited_params
		render json: @contestant
	end

	def new
		@season = Season.find(params[:season_id])
		@contestant = Contestant.new
	end

	def create
		@season = Season.find(params[:season][:season_id])
		@contestant = Contestant.new contestant_params
		if @contestant.save
			@contestant.create_status(@season)
			@season.contestants << @contestant
			flash[:notice] = "You've successfully added a new contestant."
			flash[:color] = "valid"
			redirect_to contestants_season_path(@season.id)
		else
			raise "got her"
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "prohibited"
			render :nothing
		end
	end

	private

	def contestant_params
		params.require(:contestant).permit(:name, :age, :gender, :occupation, :description, :image)
	end

	def contestant_limited_params
		params require(:contestant).permit(:name, :age, :gender, :occupation, :description)
	end
end
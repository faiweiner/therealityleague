class ContestantsController < ApplicationController
	before_action :check_if_admin

	def index
		@season = Season.find(params[:season_id])
		@contestants = Contestant.where(season_id: params[:season_id])
	end

	def edit_single
		@contestant = Contestant.find(params[:contestant_id])
	end

	def update
		@contestant = Contestant.find(params[:id])
		render json: @contestant
		# if @contestant.update
		# 	redirect_to contestants_path
		# else
		# 	render :edit
		# end
	end

	def new
		@season = Season.find(params[:season_id])
		@contestant = Contestant.new
	end

	def create
		@season = season.find(params[:contestant][:season_id])
		@contestant = Contestant.new contestant_params
		if @contestant.save
			flash[:notice] = "You've successfully added a new contestant."
			flash[:color] = "valid"
			redirect_to contestants_season_path(@contestant.season_id)
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "prohibited"
			render :new
		end
	end

	private

	def contestant_params
		params.require(:contestant).permit(:name, :season_id, :age, :gender, :occupation, :description, :status_on_season, :present, :image)
	end

end
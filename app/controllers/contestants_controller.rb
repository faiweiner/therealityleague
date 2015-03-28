class ContestantsController < ApplicationController
	before_action :check_if_admin
	layout "admin"

	def index
		@contestant = Contestant.new
		@contestants = @season.contestants
	end

	def update
		@contestant = Contestant.find(params[:id])
		@contestant.update contestant_params
		render json: @contestant
	end

	def new
		@contestant = Contestant.new
	end

	def create
		raise
		season_ids = params[:season_ids]
		@contestant = Contestant.new contestant_params
		if @contestant.save
			season_ids.each do |id|
				season = Season.find(id)
				@contestant.create_status(season)
				season.contestants << @contestant
			end
			flash[:notice] = "You've successfully added a new contestant."
			flash[:color] = "valid"
			render json: @contestant
		else
			raise "got here"
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "prohibited"
			render :nothing
		end
	end

	private

	def contestant_params
		params.require(:contestant).permit(:name, :age, :gender, :occupation, :description, :image)
	end

end
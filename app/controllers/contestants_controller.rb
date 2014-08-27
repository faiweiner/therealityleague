class ContestantsController < ApplicationController
	before_action :check_if_admin

	def index
		@show = Show.find(params[:show_id])
		@contestants = Contestant.where(show_id: params[:show_id])
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
		@show = Show.find(params[:show_id])
	end

	private

end
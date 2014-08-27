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
		@contestant = Contestant.new
	end

	def create
		@show = Show.find(params[:contestant][:show_id])
		@contestant = Contestant.new contestant_params
		if @contestant.save
			flash[:notice] = "You've successfully added a new contestant."
			flash[:color] = "valid"
			redirect_to contestants_show_path(@contestant.show_id)
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "prohibited"
			render :new
		end
	end

	private

	def contestant_params
		params.require(:contestant).permit(:name, :show_id, :age, :gender, :occupation, :description, :status_on_show, :present, :image)
	end

end
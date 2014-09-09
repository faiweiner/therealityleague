class SeasonsController < ApplicationController
	before_action :check_if_admin, :only => [:index, :new, :edit]
	def index
		@seasons = Season.where(:expired => :false).order("premiere_date ASC")
		@past_seasons = Season.where(:expired => :true).order("premiere_date DESC")
		@current_date = DateTime.now.strftime("%B %d, %Y")
	end

	def new
		@season = Season.new
	end

	def create
		@season = Season.new season_params
		if @season.save
			flash[:notice] = "You've successfully added a new season."
			flash[:color] = "valid"
			raise params
			redirect_to new_contestant_path(@season.id)
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "prohibited"
			render :new
		end
	end


	def edit
		@season = Season.find(params[:id])
	end
	
	def update
		@season = Season.find(params[:id])
		if @season.update season_params
			redirect_to seasons_path
		else
			render :edit
		end
	end

	def destroy
		@season = Season.find params[:id]
		redirect_to seasons_path
	end
	def display
		@season = Season.find(params[:id])
		@rules = @season.show.events
		@contestants = @season.contestants.order("name ASC")
		# raise
	end
	
	private

	def season_params
		params.require(:season).permit(:name, :number, :show_id, :premiere_date, :country_origin, :type, :description, :image, :expired, :episode_count, :finale_date)
	end

end
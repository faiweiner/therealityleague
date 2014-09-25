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

	def publish
		@season = Season.find(params[:id])
		if @season.update(published: true)
			flash[:notice] = "#{@season.show.name}: #{@season.name} is now published."
			flash[:color] = "valid"
			redirect_to seasons_path
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "prohibited"
			redirect_to seasons_path
		end
	end

	def unpublish
		@season = Season.find(params[:id])
		if @season.leagues.count > 0
			flash[:notice] = "#{@season.show.name}: #{@season.name} cannot be unpublished because leagues for this season already exist."
			flash[:color] = "prohibited"
			redirect_to seasons_path
		elsif @season.update(published: false)
				flash[:notice] = "#{@season.show.name}: #{@season.name} is now hidden from the public."
				flash[:color] = "valid"
				redirect_to seasons_path
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "prohibited"
			redirect_to seasons_path
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
		params.require(:season).permit(:name, :number, :show_id, :premiere_date, :finale_date, :country_origin, :type, :description, :episode_count, :image, :published, :expired)
	end

end
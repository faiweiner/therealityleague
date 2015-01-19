class SeasonsController < ApplicationController
	before_action :check_if_admin, only: [:new, :edit, :update, :publish, :unpublish, :destroy]
	before_action :check_if_logged_in, only: [:display]
	layout "admin", except: [:display]
	def index
		@current_seasons = Season.where(:expired => :false).order("premiere_date ASC")
		@past_seasons = Season.where(:expired => :true).order("premiere_date DESC")
		@current_date = DateTime.now.strftime("%B %d, %Y")
	end

	def new
		@season = Season.new(:show_id => params[:show_id])
	end

	def create
		@season = Season.new season_params
		if @season.save
			flash[:notice_show] = "You've successfully added #{@season.show.name}: #{@season.name}."
			flash[:color] = "valid"
			redirect_to contestants_season_path(@season.id)
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
			redirect_to admin_seasons_path
		else
			render :edit
		end
	end

	def publish
		@season = Season.find(params[:id])
		if @season.update(published: true)
			flash[:notice] = "#{@season.show.name}: #{@season.name} is now published."
			flash[:color] = "valid"
			redirect_to admin_seasons_path
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "prohibited"
			redirect_to admin_seasons_path
		end
	end

	def unpublish
		@season = Season.find(params[:id])
		if @season.leagues.count > 0
			flash[:notice] = "#{@season.show.name}: #{@season.name} cannot be unpublished because leagues for this season already exist."
			flash[:color] = "prohibited"
			redirect_to admin_seasons_path
		elsif @season.update(published: false)
			flash[:notice] = "#{@season.show.name}: #{@season.name} is now hidden from the public."
			flash[:color] = "valid"
			redirect_to admin_seasons_path
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "prohibited"
			redirect_to admin_seasons_path
		end
	end

	def destroy
		@season = Season.find params[:id]
		if @season.leagues.count > 0
			flash[:notice] = "#{@season.show.name}: #{@season.name} cannot be deleted because leagues for this season already exist."
			flash[:color] = "prohibited"
			redirect_to admin_seasons_path
		elsif	@season.destroy
			flash[:notice] = "#{@season.show.name}: #{@season.name} has been successfully deleted."
			flash[:color] = "valid"
			redirect_to admin_seasons_path
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "prohibited"
			redirect_to admin_seasons_path
		end
	end

	def display
		@season = Season.find(params[:id])
		@show = @season.show
		@rules_collection = get_schemes(@show)
		@contestants = @season.contestants.order("name ASC")

		@contestant_status_collection = []
		@contestants.each_with_index do |contestant, i|
			if contestant.present?
				@contestant_status_collection[i] = ""
			else
				@contestant_status_collection[i] = "eliminated"
			end
		end
		@contestants_ranking = @season.contestants.includes(:events).order(:name)

		render_admin
	end
	
	private

	def season_params
		params.require(:season).permit(:name, :number, :show_id, :premiere_date, :finale_date, :country_origin, :type, :description, :episode_count, :image, :website, :network, :published, :expired)
	end

end
class ShowsController < ApplicationController
	before_action :check_if_admin, :only => [:new, :edit]
	def index
		@shows = Show.where(:expired => :false).order("premiere_date ASC")
		@past_shows = Show.where(:expired => :true).order("premiere_date DESC")
		@current_date = DateTime.now.strftime("%B %d, %Y")
	end

	def new
		@show = Show.new
	end

	def create
		@show = Show.new show_params
		if @show.save
			flash[:notice] = "You've successfully added a new show."
			flash[:color] = "valid"
			redirect_to new_contestant_path
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "prohibited"
			render :new
		end
	end


	def edit
		@show = Show.find(params[:id])
	end
	
	def update
		@show = Show.find(params[:id])
		if @show.update show_params
			redirect_to shows_path
		else
			render :edit
		end
	end

	def destroy
		@show = Show.find params[:id]
		redirect_to shows_path
	end
	def show
		@show = Show.find(params[:id])
		@rules = @show.franchise.events
		@contestants = @show.contestants.order("name ASC")
		# raise
	end
	
	private

	def show_params
		params.require(:show).permit(:name, :premiere_date, :country_origin, :type, :description, :image, :series_id, :expired, :episode_count, :finale_date)
	end

end
class ShowsController < ApplicationController
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
			redirect_to shows_path
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

	def edit
		@show = Show.find(params[:id])
	end

	def show
		@show = Show.find(params[:id])
		@contestants = @show.contestants
		# raise
	end

	private

	def show_params
		params.require(:show).permit(:name, :premiere_date, :country_origin, :type, :description, :image, :series_id, :expired, :episode_count, :finale_date)
	end

end
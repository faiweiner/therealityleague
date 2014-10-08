class EpisodesController < ApplicationController
	def index
		@episodes = Episode.includes(:season, :show).where(:season_id => params[:season_id])		
	end

	def new
		@episode = Episode.new
	end

	def create
		@episode = Episode.new episode_params
		if @episode.save 
			flash[:notice] = "You've successfully added an episode to #{@episode.season.show.name}: #{@episode.season.name}."
			flash[:color] = "valid"
			redirect_to new_round_episode(@episode.id)
		else
			flash[:notice] = "Something went wrong, please try again."
			flash[:color] = "invalid"
		end
	end

	def display
		@episode = Episode.find(params[:id])	
	end

	private

	def episode_params
		params.require(:episode).permit(:season_id, :air_date)
	end
end

class RoundsController < ApplicationController
	def new
		episode = Episode.find(params[:episode_id])
		season = Season.includes(:episodes).find(episode.season_id)
		redirect_to root_path
	end
end

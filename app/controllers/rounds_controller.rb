class RoundsController < ApplicationController
	def new
		episode = Episode.find(params[:episode_id])
		season = Season.includes(:episodes).find(episode.season_id)
		raise
	end
end

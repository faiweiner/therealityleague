class RoundsController < ApplicationController

	def create
		@roster = Roster.includes(:league, :contestants).find(params[:roster_id])

		season = @roster.league.season
		episode_number = params[:episode_number].to_i + 1
		episode = season.episodes[episode_number]

		@round = Round.find_or_create_by!(:roster_id => @roster.id, :episode_id => episode.id)

		respond_to do |format|
			format.js {
				render :json => { 
					:round => @round }
			}
		end
	end

	def add

	end
end

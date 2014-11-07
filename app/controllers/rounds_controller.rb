class RoundsController < ApplicationController

	def index
		@roster = Roster.includes(:league, :contestants).find(params[:roster_id])

		season = @roster.league.season
		origin_box = params[:origin_box_number].to_i			#contestant box will always be -1
		target_episode_number = origin_box + 1						# +1 to reflect array's position
		episode = season.episodes[target_episode_number]	#getting target episode ID for the round

		@round = Round.find_or_create_by!(:roster_id => @roster.id, :episode_id => episode.id)

		respond_to do |format|
			format.js {
				render :json => { 
					:round => @round }
			}
		end

	end

	def add
		# adding contestants to a round
		@round = Round.includes(:roster, :episode, :contestants).find(params[:round_id])
		roster = @round.roster
		episode = @round.episode

		contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id] != nil

		@round.contestants << contestant unless @round.contestants.include? contestant

		respond_to do |format|
			format.js {
				render :json => { 
					:round => @round,
					:contestants => @round.contestants,
					:roster => roster,
					:episode => episode
				}
			}
		end

		
		def display
			
			respond_to do |format|
				format.html
			end

		end
	end
end

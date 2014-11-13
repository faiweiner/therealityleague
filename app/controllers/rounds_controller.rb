class RoundsController < ApplicationController

	def index
		@rounds_collection = Round.where(league_id: params[:league_id])
	
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

	def edit
		@league = League.find(params[:league_id])	
	end

	def add
		# adding a contestant to a round
		@round = Round.includes(:contestants).find(params[:round_id])
		contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id] != nil

		@round.contestants << contestant unless @round.contestants.include? contestant

		redirect_to round_display_path(@round.id)
	end

	def remove
		# removing a contestant from a round
		@round = Round.includes(:contestants).find(params[:round_id])
		contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id] != nil

		@round.contestants.destroy(contestant)

		redirect_to round_display_path(@round.id)
	end
		
	def display
		@round = Round.includes(:roster, :episode, :contestants).find(params[:round_id])
		respond_to do |format|
			format.html
			format.js {
				render :json => { 
					:round => @round }
			}
		end
	end

end
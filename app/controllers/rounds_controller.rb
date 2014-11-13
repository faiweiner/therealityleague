class RoundsController < ApplicationController

	def index
		@rounds_collection = Round.includes(:league, :user).where(league_id: params[:league_id], user_id: params[:user_id])
		@league = League.includes(:season).find(params[:league_id])
		@season = @league.season
		show = @season.show
		origin_box = params[:origin_box_number].to_i			#contestant box will always be -1
		target_episode_number = origin_box + 1						# +1 to reflect array's position
		episode = @season.episodes[target_episode_number]	#getting target episode ID for the round
	end

	def edit
		@league = League.find(params[:league_id])	
		@season = Season.includes(:show, :episodes, :contestants).find(@league.season.id)
		@episodes_collection = @season.episodes
		first_episode = @episodes_collection[0]
		@rounds_collection = Round.where(:user_id => @current_user.id, :league_id => @league.id)

		if @rounds_collection.count == 0
			@round = Round.find_or_create_by!(:user_id => @current_user.id, :league_id => @league.id, :episode_id => first_episode.id)
		else
			@round = @rounds_collection.first
		end
		@all_contestants = @season.contestants
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
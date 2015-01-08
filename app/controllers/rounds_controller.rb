class RoundsController < ApplicationController

	def index
		@rounds_collection = Round.includes(:league, :user).where(league_id: params[:league_id], user_id: params[:user_id])
		@league = League.includes(:season).find(params[:league_id])
		@season = @league.season
		@user = User.find(params[:user_id])
		show = @season.show
		origin_box = params[:origin_box_number].to_i			#contestant box will always be -1
		target_episode_number = origin_box + 1						# +1 to reflect array's position
		episode = @season.episodes[target_episode_number]	#getting target episode ID for the round
	end

	def create
		@league = League.find(params[:league_id])	
		@season = Season.includes(:show, :episodes, :contestants).find(@league.season.id)
		
		# @season must already have recorded episodes in order to work
		@episodes_collection = @season.episodes
		@episodes_collection.each do |episode|
			round = Round.find_or_create_by!(:user_id => @current_user.id, :league_id => @league.id, :episode_id => episode.id)
		end

		redirect_to rounds_edit_path(@league.id)
	end

	def edit
		@league = League.includes(:users, :rounds).find(params[:league_id])	
		@season = Season.includes(:show, :episodes, :contestants).find(@league.season.id)
		@episodes_collection = @season.episodes
		
		@rounds_collection = @league.rounds.where(:user_id => @current_user.id)
		@rounds_ids = @rounds_collection.pluck(:id)

		@upcoming_rounds = []
		@rounds_collection.each do |round|
			if round.episode.air_date.future?
				@upcoming_rounds << round
			end
		end

		@available_contestants = @season.contestants.where(present: true).order(name: :asc)
		respond_to do |format|
			format.html
			format.js {
				render :json => {
					:rounds_collection => @rounds_collection,
					:rounds_ids => @rounds_ids
				}
			}
		end
	end

	def singleedit
		@round = Round.includes(:user, :league).find(params[:round_id])	
		@league = @round.league
		@season = Season.includes(:show, :episodes, :contestants).find(@league.season.id)
		@episodes_collection = @season.episodes

		@available_contestants = @season.contestants.where(present: true).order(name: :asc)
		respond_to do |format|
			format.html
			format.js {
				render :json => {
					:rounds_collection => @rounds_collection,
					:rounds_ids => @rounds_ids
				}
			}
		end
	end

	def add
		# adding a contestant to a round
		@round = Round.includes(:contestants).find(params[:round_id])
		@league = @round.league
		contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id] != nil

		@round.contestants << contestant unless @round.contestants.include? contestant

		@rounds_collection = @league.rounds.where(:user_id => @current_user.id)
		@upcoming_rounds = []
			@rounds_collection.each do |round|
			if round.episode.air_date.future?
				@upcoming_rounds << round
			end
		end

		respond_to do |format|
			format.html { render partial: "current_bracket", :remote => true }
			format.js {
				render :json => {
					:round => @round,
					:contestants => @round.contestants
				}
			}
		end

	end

	def remove
		# removing a contestant from a round
		@round = Round.includes(:contestants).find(params[:round_id])
		@league = @round.league
		contestant = Contestant.find(params[:contestant_id]) if params[:contestant_id] != nil

		@round.contestants.destroy(contestant)

		@rounds_collection = @league.rounds.where(:user_id => @current_user.id).includes(:contestants)
		@upcoming_rounds = []
			@rounds_collection.each do |round|
			if round.episode.air_date.future?
				@upcoming_rounds << round
			end
		end

		respond_to do |format|
			format.html { render partial: "current_bracket", :remote => true }
			format.js {
				render :json => {
					:round => @round,
					:contestants => @round.contestants,
					:rounds_collection =>	@rounds_collection
				}
			}
		end

	end
	
	def save
		@round = Round.includes(:user, :league, :episode).find(params[:round_id])
		@user = @round.user
		@league = @round.league
		@episode = @round.episode

		respond_to do |format|
			format.js {
				render :json => {
					:round => @round,
					:league => @league,
					:episode => @episode
				}
			}
		end
	end

	def previous
		
	end

	def display
		@round = Round.includes(:episode, :contestants).find(params[:round_id])
		@selected_contestants = @round.contestants.order(name: :asc)
		respond_to do |format|
			format.js {
				render :json => { 
					:round => @round,
					:selectedContestants => @selected_contestants }
			}
		end
	end

	def available
		@round = Round.includes(:episode, :contestants).find(params[:round_id])
		@available_contestants = []
		all_contestants = episode.season.contestants
		all_contestants.each do |contestant|
			@available_contestants << contestant unless @round.contestants.include? contestant
		end
		respond_to do |format|
			format.js {
				render :json => {
					:availableContestants => @available_contestants
				}
			}
		end
	end

end
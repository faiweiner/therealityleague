class RoundsController < ApplicationController

	def index
		@rounds_collection = Round.includes(:league, :user).where(league_id: params[:league_id], user_id: params[:user_id])
		@league = League.includes(:season).find(params[:league_id])
		@season = @league.season
		@episodes_id = @season.episodes.pluck(:id) 
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
		
		# -- collection of episodes and episode IDs for this season for list of absent episodes by contestant
		@episodes_collection = @season.episodes.order(air_date: :asc)
		@episodes_ids_collection = @episodes_collection.pluck(:id)

		# -- collection of rounds by this user for this league
		@rounds_collection = @league.rounds.where(:user_id => @current_user.id).order(episode_id: :asc)
		@rounds_ids_collection = @rounds_collection.pluck(:id)
		@upcoming_rounds = []
		@rounds_collection.each do |round|
			if round.episode.air_date.future?
				@upcoming_rounds << round
			end
		end

		# -- get an ordered array of rounds and episodes together
		@rounds_episodes_collection = []
		@rounds_collection.each do |round|
			@rounds_episodes_collection << {round.id => round.episode_id}
		end

		# -- get information about contestant for rounds.js
		@contestants = @season.contestants.order(name: :asc)
		@contestants_data_collection = {}
		@contestants.each do |contestant|

			if contestant.present == false 
				eliminated = true
				elimination_episode = contestant.episode_id 
			else
				elimination = true
				elimination_episode = nil
			end

			## -- produces a collection of episodes (ID) where that contestant is absent 
			## -- (i.e) this contestant has already been eliminated.
			present_episodes = []
			absent_episodes = []
			@episodes_ids_collection.each_with_index do |episode_id, i|
				unless contestant.episode_id.nil?
					if episode_id >= contestant.episode_id
						absent_episodes << episode_id
					else
						present_episodes << episode_id
					end
				end
				present_episodes << episode_id
			end

			## -- get the rounds which the contestant is picked
			rounds_picked = []
			@rounds_collection.each do |round|
				rounds_picked << round.id if round.contestants.include? contestant
			end

			## -- get episodes where contestant is absent (i.e. already eliminated)
			absent_episode = []

			# -- collection for rounds.js
			@contestants_data_collection[contestant.id] = {
				:img => contestant.image,
				:alt => contestant.name,
				:rounds_picked => rounds_picked,
				:eliminated => eliminated,
				:elimination_episode => elimination_episode,
				:absent_episodes_collection => absent_episodes
			}
		end

		respond_to do |format|
			format.html
			format.js {
				render :json => {
					:rounds_ids => @rounds_ids_collection,
					:rounds_collection => @rounds_collection,
					:contestants_data_collection => @contestants_data_collection
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
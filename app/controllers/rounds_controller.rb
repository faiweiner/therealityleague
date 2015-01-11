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
	
			# populate the first(ep.2) round with all contestants
			if episode.first? && @season.show.name == "The Bachelor"
				@season.contestants.each do |contestant|
					round.contestants << contestant
				end
			end
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

		case @season.show.name 
		when "The Bachelor" 
			if @league.draft_deadline.future? && (@episodes_collection[0].air_date.past? && @episodes_collection[1].air_date.future?)
				if @rounds_collection[1].contestants.empty?
					@rounds_collection[0].contestants.where(present: true).each do |contestant|
						@rounds_collection[1].contestants << contestant unless @rounds_collection[1].contestants.include? contestant
					end
				end
			end
		end

		# -- get information about contestant for rounds.js
		@contestants = @season.contestants.order(name: :asc)
		@contestants_data_collection = Hash.new
		@contestants.each do |contestant|

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

			## -- get the rounds which the contestant is picked by the user
			rounds_picked = []
			@rounds_collection.each do |round|
				rounds_picked << round.id if round.contestants.include? contestant
			end

			## -- get episodes where contestant is absent (i.e. already eliminated)
			absent_episode = []

			# -- collection for rounds.js
			@contestants_data_collection[contestant.id] = {
				:rounds_picked_collection => rounds_picked,
				:absent_episodes_collection => absent_episodes
			}
		end
		
		@rounds_data_collection = Hash.new
		round_status = ""
		@rounds_collection.each do |round|

			count_difference = round.contestants.count - round.episode.expected_survivors
			round_action = "landing"
			
			case count_difference == 0
			when true
				round_status = "alert-success"
			when false
				if count_difference > 0
					round_status = "alert-danger"
				else
					round_status = "alert-warning"
				end
			end

			@rounds_data_collection[round.id] = {
				:round_status => round_status,
				:count_difference => count_difference,
				:round_action => round_action,
				:round_message => get_round_message(round.id, round_status, count_difference, round_action)
			}
		end

		respond_to do |format|
			format.html
			format.js {
				render :json => {
					:rounds_ids => @rounds_ids_collection,
					:rounds_collection => @rounds_collection,
					:contestants_data_collection => @contestants_data_collection,
					:rounds_data_collection => @rounds_data_collection
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
		process_and_return(params[:contestant_id], params[:round_id], "add")
	end

	def remove
		process_and_return(params[:contestant_id], params[:round_id], "remove")
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

	protected

	def process_and_return(contestant_id, round_id, action)
		contestant = Contestant.find(contestant_id) if contestant_id != nil
		round = Round.includes(:league, :contestants).find(round_id)
		
		case action
		when "add"
			round.contestants << contestant unless round.contestants.include? contestant
		when "remove"
			round.contestants.destroy(contestant)
		end

		@league = round.league
		@season = @league.season
		@episodes_collection = @season.episodes.order(air_date: :asc)
		@episodes_ids_collection = @episodes_collection.pluck(:id)
		
		@rounds_collection = @league.rounds.where(:user_id => @current_user.id).includes(:contestants)
		@contestants = @season.contestants.order(name: :asc)
		
		@contestants_data_collection = {}
		@contestants.each do |contestant|
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

			# -- collection for rounds.js
			@contestants_data_collection[contestant.id] = {
				:rounds_picked_collection => rounds_picked,
				:absent_episodes_collection => absent_episodes
			}

		end
		
		@upcoming_rounds = []
			@rounds_collection.each do |round|
			if round.episode.air_date.future?
				@upcoming_rounds << round
			end
		end

		@rounds_data_collection = Hash.new
		@rounds_collection.each do |round|

			round_status = ""
			count_difference = round.contestants.count - round.episode.expected_survivors
			round_action = action
	
			case count_difference == 0
			when true
				round_status = "alert-success"
			when false
				if count_difference > 0
					round_status = "alert-danger"
				else
					round_status = "alert-warning"
				end
			end
			
			@rounds_data_collection[round.id] = {
				:round_status => round_status,
				:count_difference => 0,
				:round_action => round_action,
				:round_message => get_round_message(round.id, round_status, count_difference, round_action)
			}
		end		
		respond_to do |format|
			format.html { 
				render partial: "current_bracket", :remote => true 
			}
			format.json { 
				render :json => {
					:round => round,
					:contestants => @contestants,
					:rounds_collection =>	@rounds_collection
				}
			}
		end
	end

	def get_round_message(round_id, status, count_difference, action)
		round_message = Hash.new
		case status
		when "alert-success"
			round_message = {
				:contentHero => "Fantastic!",
				:contentSupport => {
					:a => "Click \"Next\" to pick contestants for the next episode.",
					:b => ""
				},
				:contentCountDifference => nil,
				:contentDate => "#{@league.draft_deadline.strftime("%D")}."
			}
		when "alert-warning"
			if action == "add"
				round_message = {
					:contentHero => "",
					:contentSupport => {
						:a => "Add",
						:b => "to complete your roster."
					},
					:contentCountDifference => count_difference,
					:contentDate => nil
				}
			elsif action == "overadd"
				round_message = {
					:contentHero => "TOOK TOOK",
					:contentSupport => {
						:a => "Please remove a contestant from your current roster before adding a new one.",
						:b => ""
					},
					:contentCountDifference => nil,
					:contentDate => nil
				}
			else action == "landing"
				round_message = {
					:contentHero => "Pick your contestants!",
					:contentSupport => {
						:a => "Add",
						:b => "to your roster before the league's draft deadline on"
					},
					:contentCountDifference => count_difference.abs,
					:contentDate => "#{@league.draft_deadline.strftime("%D")}."
				}				
			end
		when "alert-danger"
			round_message = {
				:contentHero => "You have too many contestants in your roster!",
				:contentSupport => {
					:a => "Remove",
					:b => "to complete your roster."
				},
				:contentCountDifference => count_difference,
				:contentDate => nil
			}		
		else
		end		
	end

end
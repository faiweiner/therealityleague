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
		static_data_pack = get_static_data(@league.id)
		data_package = get_round_data(@league.id, "landing")
		
		@episodes_collection = static_data_pack[:episodes_collection]
		@episodes_ids_collection = static_data_pack[:episodes_ids_collection]
		@rounds_collection = static_data_pack[:rounds_collection]
		@rounds_ids_collection = static_data_pack[:rounds_ids_collection]
		@upcoming_rounds_ids = static_data_pack[:upcoming_rounds_ids]
		@contestants_data_collection = data_package[:contestants_data_collection]
		
		if @season.show.name == "The Bachelor" && @rounds_collection[0].contestants.empty?
			bulk_add_contestants(@upcoming_rounds_ids[1], @upcoming_rounds_ids)
			bulk_add_contestants(@upcoming_rounds_ids[1], @upcoming_rounds_ids)
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

	def bulk_add
		process_and_return(params[:contestant_id], params[:round_id], "bulk_add")
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

	def bulk_add_contestants(round_id, rounds_ids_collection)
		round = Round.includes(:league).find(round_id)
		season = round.league.season
		rounds_array = rounds_ids_collection
		round_index = rounds_array.index(round.id).to_i
		
		if round.league.draft_deadline.future? && round.episode.air_date.future?
			if round_index == 0
				season.contestants.where(present: true).each do |contestant|
					round.contestants << contestant unless round.contestants.include? contestant
				end
				return "Added contestants to current round."
			else
				prev_round_id = rounds_array[round_index - 1]
				prev_round = Round.find(prev_round_id)
				round.contestants = roundA.contestants.dup
				return "Added contestants from previous round to current round."
			end
		else
			return "You cannot bulk add because round already contains contestants."
		end
	end

	def bulk_delete_contestants(round_id)
		round = Round.includes(:league).find(round_id)
		round.contestants.each do |contestant|
			round.contestants.destroy(contestant)
		end
	end

	def get_static_data(league_id)
		league = League.includes(:users, :rounds, :season).find(league_id)	
		rounds_collection = league.rounds.where(:user_id => @current_user.id).order(episode_id: :asc)
		rounds_ids_collection = rounds_collection.pluck(:id)
		episodes_collection = league.season.episodes.order(air_date: :asc)
		episodes_ids_collection = episodes_collection.pluck(:id)
		contestants_collection = league.season.contestants.order(name: :asc)

		upcoming_rounds_ids = []
		rounds_collection.each do |round|
			upcoming_rounds_ids << round.id if round.episode.air_date.future?
		end

		static_data_pack = Hash.new
		static_data_pack = {
			:rounds_collection => rounds_collection,
			:rounds_ids_collection => rounds_ids_collection,
			:episodes_collection => episodes_collection,
			:episodes_ids_collection => episodes_ids_collection,
			:contestants_collection => contestants_collection,
			:upcoming_rounds_ids => upcoming_rounds_ids
		}
		return static_data_pack
	end
	
	def get_round_data(league_id, round_action)
		@league = League.includes(:users, :rounds, :season).find(league_id)	
		@season = Season.includes(:show, :episodes, :contestants).find(@league.season.id)
		
		static_data_pack = get_static_data(@league.id)

		@contestants = static_data_pack[:contestants_collection]
		@rounds_collection = static_data_pack[:rounds_collection]
		@upcoming_rounds_ids = static_data_pack[:upcoming_rounds_ids]
		@episodes_collection = static_data_pack[:episodes_collection]
		@episodes_ids_collection = static_data_pack[:episodes_ids_collection]

		@rounds_data_collection = Hash.new
		prev_round_id, next_round_id = 0
		@rounds_collection.each_with_index do |round, i|
			prev_round_id = @rounds_collection[i-1].id if @rounds_collection[i-1].present?
			next_round_id = @rounds_collection[i+1].id if @rounds_collection[i+1].present?
		end
		# ==== CONTESTANTS DATA ====
		@contestants_data_collection = Hash.new
		@contestants.each do |contestant|
			present_episodes_ids = []
			absent_episodes_ids = []

			@episodes_ids_collection.each_with_index do |episode_id, i|
				unless contestant.episode_id.nil?
					if episode_id >= contestant.episode_id
						absent_episodes_ids << episode_id
					else
						present_episodes_ids << episode_id
					end
				end
				present_episodes_ids << episode_id
			end

			contestant_round_data = Hash.new
			round_data = Hash.new
			status = ""
			label = ""
			action_element_label = ""
			glyphicon = ""
			@rounds_collection.each_with_index do |round, i|
				if contestant.present == false									# ELIMINATED contestants (on show level)
					status = "eliminated"
					label = "ELIMINATED"
					action_element_label = "available pick eliminated"
					glyphicon = ""
				elsif round.contestants.include? contestant			# contestant included in a round
					status = "selected"
					label = ""
					action_element_label = "selected discard"
					glyphicon = "glyphicon glyphicon-remove"
				elsif @rounds_collection[i-1].contestants.include? contestant			# contestant included in LAST round
					status = "last-picked"
					label = ""
					action_element_label = "available pick"
					glyphicon = "glyphicon glyphicon-ok"
				else
					status = "eliminated"
					label = ""
					action_element_label = "available pick eliminated"
					glyphicon = ""
				end
				round_data[round.id] = {
					:status => status,
					:label => label,
					:action => action_element_label,
					:glyphicon => glyphicon
				}
			end

			# -- collection for rounds.js
			@contestants_data_collection[contestant.id] = {
				:round_data => round_data,
				:present_episodes_ids => present_episodes_ids,
				:absent_episodes_ids => absent_episodes_ids
			}

		end
		# ==== END CONTESTANT DATA ==== #
		
		# ==== ROUND DATA ==== #
		@rounds_data_collection = Hash.new
		round_status = ""
		@rounds_collection.each do |round|

			count_difference = round.contestants.count - round.episode.expected_survivors
			
			case count_difference == 0
			when true
				round_status = "alert-success"
			when false
				if count_difference < 0
					round_status = "alert-danger"
				else
					round_status = "alert-warning"
				end
			end

			@rounds_data_collection[round.id] = {
				:round_status => round_status,
				:count_difference => count_difference,
				:round_action => round_action,
				:round_message => get_round_message(round.id, round_status, count_difference, round_action),
				:prev_round_id => prev_round_id,
				:next_round_id => next_round_id
			}
		end

		# ==== END ROUND DATA ==== #

		data_package = {
			:contestants_data_collection => @contestants_data_collection,
			:rounds_data_collection => @rounds_data_collection
		}

		return data_package

	end

	def process_and_return(contestant_id, round_id, action)
		contestant = Contestant.find(contestant_id) if contestant_id != nil
		round = Round.includes(:league, :contestants).find(round_id)
		@league = round.league
		@season = @league.season
		@contestants = @season.contestants.order(name: :asc)
		
		static_data_pack = get_static_data(@league.id)

		case action
		when "add"
			round.contestants << contestant unless round.contestants.include? contestant
		when "remove"
			round.contestants.destroy(contestant)
		when "bulk_add"
			bulk_add_contestants(round_id, static_data_pack[:upcoming_rounds_ids])
		end		


		data_package = get_round_data(@league.id, action)	
		@episodes_collection = static_data_pack[:episodes_collection]
		@episodes_ids_collection = static_data_pack[:episodes_ids_collection]
		@rounds_collection = static_data_pack[:rounds_collection]
		@rounds_ids_collection = static_data_pack[:rounds_ids_collection]
		@upcoming_rounds_ids = static_data_pack[:upcoming_rounds_ids]
		@contestants_data_collection = data_package[:contestants_data_collection]
		@rounds_data_collection = data_package[:rounds_data_collection]
		

		respond_to do |format|
			format.html { 
				render partial: "current_bracket", :remote => true 
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
					:a => "Click \"Next\" to pick contestants for the next episode",
					:b => "or \"Finish\" if you've selected the sole winner!"
				},
				:contentCountDifference => nil,
				:contentDate => nil
			}
		when "alert-warning"			
			if action == "add"
				round_message = {
					:contentHero => "Oops! ",
					:contentSupport => {
						:a => "You didn't discard enough contestants for this this episode. Remove",
						:b => "before moving on to the next episode."
					},
					:contentCountDifference => count_difference,
					:contentDate => nil
				}
			elsif action == "landing"
				round_message = {
					:contentHero => "Who will bite the dust?",
					:contentSupport => {
						:a => "Discard ",
						:b => "you think will get eliminated during this episode."
					},
					:contentCountDifference => count_difference,
					:contentDate => "#{@league.draft_deadline.strftime("%D")}."
				}	
			elsif action == "overadd"
				round_message = {
					:contentHero => "Oops!",
					:contentSupport => {
						:a => "You didn't discard enough contestants for this this episode. Remove",
						:b => "before moving on to the next episode."
					},
					:contentCountDifference => count_difference,
					:contentDate => nil
				}
			elsif action == "remove"
				round_message = {
					:contentHero => "Keep going!",
					:contentSupport => {
						:a => "Discard",
						:b => "more before moving on to the next round."
					},
					:contentCountDifference => count_difference,
					:contentDate => nil
				}
			end
		when "alert-danger"
			if action == "landing"
				round_message = {
					:contentHero => "Who will make it to the next round?",
					:contentSupport => {
						:a => "Select",
						:b => "you think will make it through the episode."
					},
					:contentCountDifference => count_difference.abs,
					:contentDate => nil
				}	
			elsif action == "add"
				round_message = {
					:contentHero => "Keep going!",
					:contentSupport => {
						:a => "Select",
						:b => "you think will make it through the episode."
					},
					:contentCountDifference => count_difference.abs,
					:contentDate => nil
				}
			elsif action == "remove"
				round_message = {
					:contentHero => "Keep going!",
					:contentSupport => {
						:a => "Select",
						:b => "you think will make it through the episode."
					},
					:contentCountDifference => count_difference.abs,
					:contentDate => nil
				}
			end
		end		
	end

end
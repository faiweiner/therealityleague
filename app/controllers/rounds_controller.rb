class RoundsController < ApplicationController

	def index
		# general data pull from server
		@rounds_collection = Round.includes(:league, :user).where(league_id: params[:league_id], user_id: params[:user_id])
		@league = League.includes(:season).find(params[:league_id])
		@season = @league.season
		@contestants = @season.contestants.order(name: :asc)
		@user = User.find(params[:user_id])
		show = @season.show

		# cross-check with statuses #FIXME
		statuses = Status.where(season_id: @season.id).order(contestant_id: :asc)
		expelled_statuses = statuses.select{|status| status.present == false}
		expelled_contestants_ids = []

		# pull Survival and Expulsion schemes
		@schemes = Scheme.where(show_id: show.id, type: ["Survival", "Expulsion"])
		@survival_schemes_ids = @schemes.order(id: :asc).select{|scheme| scheme.type == "Survival"}.collect{|scheme| scheme.id}
		@expulsion_schemes_ids = @schemes.order(id: :asc).select{|scheme| scheme.type == "Expulsion"}.collect{|scheme| scheme.id}

		@rounds_data_package = {}
		round_expulsion_data_package = {}

		# get display data per ROUND
		@rounds_collection.each_with_index do |round, i|
			# header
			if round == @rounds_collection.last
				header = "Finale"
			else
				header = "Episode #{i+1}"
			end
			# get expulsions per ROUND
			round_expulsion_events = Event.where(episode_id: round.episode.id, scheme_id: @expulsion_schemes_ids)
			round_expelled_contestants_ids = round_expulsion_events.pluck(:contestant_id)
			round_expelled_contestants_ids.each {|id| expelled_contestants_ids.push id}
			round_expulsion_data_package = {
				:expulsion_events => round_expulsion_events,
				:round_expelled_contestants_ids => round_expelled_contestants_ids,
				:complete_expelled_contestants_ids => expelled_contestants_ids
			} 	
			# generate contestant data per ROUND
			rounds_contestants_data = {}
			@contestants.each do |contestant|
				# mark if contestant is part of the round's eliminated pool
				if round.contestants.include? contestant
					selection = "glyphicon glyphicon-ok-circle" 
					c_class = "selected-contestant"
					tr_class = "success"
					# change class if selected contestant got eliminated
					if expelled_contestants_ids.include? contestant.id
						selection = ""
						c_class = "incorrect-selected-contestant"
						tr_class = "danger"
					end
					# generate contestant data per ROUND
					rounds_contestants_data[contestant] = {
						:tr_class => tr_class,
						:class => c_class,
						:selection_icon => selection
					}
					end
				end
			@rounds_data_package[round] = {
				:index => i, 
				:header => header,
				:contestants_data => rounds_contestants_data,
				:expulsion => round_expulsion_data_package
			}
		end
	end

	def create
		@league = League.find(params[:league_id])	
		@season = Season.includes(:show, :episodes, :contestants).find(@league.season.id)

		@league.users << @current_user unless @league.users.include? @current_user
		# @season must already have recorded episodes in order to work
		@episodes_collection = @season.episodes
		@episodes_collection.each_with_index do |episode, i|
			round = Round.find_or_create_by!(:user_id => @current_user.id, :league_id => @league.id, :episode_id => episode.id)
	
			# populate the first(ep.2) round with all contestants
			if i == 0
				@season.contestants.each do |contestant|
					round.contestants << contestant unless round.contestants.include? contestant
				end
			end
		end

		redirect_to rounds_edit_path(@league.id, "first")
	end

	def edit
		@league = League.includes(:users, :rounds).find(params[:league_id])	

		if params[:round_id] == "first"
			@active_round = @league.rounds.where(user_id: @current_user.id).first
		else
			@active_round = @league.rounds.find(params[:round_id])
		end
		
		if @active_round.user_id != @current_user.id
			flash[:notice] = "You do not have permission to edit this bracket!"
			flash[:color] = "warning alert-warning"
			redirect_to league_path(@league.id)
		end

		@season = Season.includes(:show, :episodes, :contestants).find(@league.season.id)
		@contestants = @season.contestants
		
		# -- collection of episodes and episode IDs for this season for list of absent episodes by contestant
		static_data_pack = get_static_data(@league.id)
		
		# populating first round with all contetants - user can eliminate people off of round
		if @active_round.contestants.empty?
			bulk_add_contestants(@active_round.id, static_data_pack[:rounds_ids_collection])
		end

		round_data_package = get_round_data(@active_round.id, @league.id, "landing")
		@round_data_collection = round_data_package
		@episodes_ids_collection = static_data_pack[:episodes_ids_collection]
		@rounds_ids_collection = static_data_pack[:rounds_ids_collection]
		@upcoming_rounds_ids_collection = static_data_pack[:upcoming_rounds_ids]
	
		action_packet = get_round_actions(@active_round, static_data_pack, round_data_package)
		@episode_pack = get_episode_action(@active_round.id, @round_data_collection[:round_status], @rounds_ids_collection)

		@active_round_index = action_packet[:active_round_index]
		@active_round_title = action_packet[:active_round_title]
		@previous_button = action_packet[:previous_button]
		@next_button = action_packet[:next_button]
		@previous_round_id = action_packet[:previous_round_id]
		@next_round_id = action_packet[:next_round_id]

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
		@active_round = Round.includes(:episode, :contestants).find(params[:round_id])
		@league = League.includes(:users, :rounds).find(@active_round.league.id)	
		@season = Season.includes(:show, :episodes, :contestants).find(@league.season.id)
		@contestants = @season.contestants

		static_data_package = get_static_data(@league.id)

		@episodes_ids_collection = static_data_package[:episodes_ids_collection]
		@rounds_ids_collection = static_data_package[:rounds_ids_collection]
		@upcoming_rounds_ids_collection = static_data_package[:upcoming_rounds_ids]

		if @rounds_ids_collection[@active_round.user_id].index(@active_round.id) == 0
			previous_round = nil
		else
			current_index = @rounds_ids_collection[@active_round.user_id].index(@active_round.id)
			previous_index = current_index - 1
			previous_round = Round.find(@rounds_ids_collection[@active_round.user_id][previous_index])
		end

		if @active_round.contestants.empty? && previous_round.present?
			previous_round.contestants.each do |contestant|
				@active_round.contestants << contestant unless @active_round.contestants.include? contestant
			end
		end

		round_data_package = get_round_data(@active_round.id, @league.id, "landing")

		action_packet = get_round_actions(@active_round, static_data_package, round_data_package)
		@episode_pack = get_episode_action(@active_round.id, round_data_package[:status], @rounds_ids_collection)

		@active_round_index = action_packet[:active_round_index]
		@active_round_title = action_packet[:active_round_title]
		@previous_button = action_packet[:previous_button]
		@next_button = action_packet[:next_button]
		@previous_round_id = action_packet[:previous_round_id]
		@next_round_id = action_packet[:next_round_id]
		respond_to do |format|
			format.html { 
				render partial: "current_bracket", :remote => true 
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
				round.contestants = prev_round.contestants.dup
				return "Added contestants from previous round to current round."
			end
		else
			return "You cannot bulk add because round already contains contestants."
		end
	end

	def cascade_delete_contestant(contestant_id, round_id, rounds_ids_collection)
		contestant = Contestant.find(contestant_id)
		round = Round.includes(:league).find(round_id)
		round_index = rounds_ids_collection.index(round.id)
		next_rounds_ids_collection = []
		rounds_ids_collection.each do |id|
			next_rounds_ids_collection << id if id > round.id
		end

		next_rounds_ids_collection.each do |id|
			r = Round.find(id)
			if r.contestants.where(id: contestant.id).any?
				r.contestants.destroy(contestant)
			end
		end
		round.contestants.destroy(contestant)
	end


	def get_static_data(league_id)		# static data for ALL the leagues
		league = League.includes(:users, :rounds, :season).find(league_id)	
		participants_ids_collection = league.users.pluck(:id)
		rounds_ids_collection = {}
		upcoming_rounds_ids = {}
		participants_ids_collection.each do |p_id|
			rounds_ids_collection[p_id] = league.rounds.where(user_id: p_id).pluck(:id)
			rounds_ids_collection[p_id].each do |id|
				upcoming_rounds_ids[p_id] = id if Round.find(id).episode.air_date.future?
			end
		end
		episodes_ids_collection = league.season.episodes.pluck(:id)
		contestants_ids_collection = league.season.contestants.order(name: :asc).pluck(:id)

		static_data_package = Hash.new
		static_data_package = {
			:rounds_ids_collection => rounds_ids_collection,
			:episodes_ids_collection => episodes_ids_collection,
			:contestants_ids_collection => contestants_ids_collection,
			:upcoming_rounds_ids => upcoming_rounds_ids
		}
		return static_data_package
	end
	
	def get_round_data(round_id, league_id, round_action)
		@league = League.includes(:users, :rounds, :season).find(league_id)	
		@season = Season.includes(:show, :episodes, :contestants).find(@league.season.id)
		current_round = Round.find(round_id)
		

		static_data_pack = get_static_data(@league.id)
		
		rounds_ids_collection = static_data_pack[:rounds_ids_collection][current_round.user_id]
		episodes_ids_collection = static_data_pack[:episodes_ids_collection]
		contestants_ids_collection = static_data_pack[:contestants_ids_collection]
		upcoming_rounds_ids = static_data_pack[:upcoming_rounds_ids][current_round.user_id]

		current_round_index = rounds_ids_collection.index(current_round.id)

		previous_round, previous_round_id, next_round, next_round_id = nil
		previous_round_index = current_round_index - 1


		next_round_index = current_round_index + 1

		if current_round.id == rounds_ids_collection[0]
			previous_round = nil
			next_round = Round.find(rounds_ids_collection[(next_round_index)])
			next_round_id = next_round.id
		elsif current_round.id == rounds_ids_collection[-1]
			previous_round = Round.find(rounds_ids_collection[previous_round_index])
			previous_round_id = previous_round.id
			next_round = nil
		else
			previous_round = Round.find(rounds_ids_collection[previous_round_index])
			previous_round_id = previous_round.id
			next_round = Round.find(rounds_ids_collection[next_round_index])
			next_round_id = next_round.id
		end

		# ==== CONTESTANTS DATA ====
		round_contestants_data_collection = Hash.new
		contestants_ids_collection.each_with_index do |contestant_id, i|
			contestant = Contestant.where(id: contestant_id).first
			status = ""
			label = ""
			i_label = ""
			action_element_label = ""
			glyphicon = ""

			# ELIMINATED contestants (on show level)
			if contestant.present? == false									
				status = "eliminated"
				label = "ELIMINATED"
				action_element_label = "available pick eliminated"
				glyphicon = ""
			# PRESENT contestants
			else
				# in current round?
				if current_round.contestants.include? contestant			# contestant included in a round
					status = "selected"
					label = ""
					i_label = "marker glyphicon glyphicon-ok"
					action_element_label = "selected discard"
					glyphicon = "glyphicon glyphicon-remove"
				# NOT in current round
				else
					# was contestant picked in the last round?
					if previous_round.present? && (previous_round.contestants.include? contestant)			# contestant included in LAST round
						status = "last-picked"
						label = ""
						i_label = ""
						action_element_label = "available pick"
						glyphicon = "glyphicon glyphicon-ok"
					# if contestant wasn't picked in the last round
					else
						if current_round_index == 0
							status = "not-picked"
							label = ""
							action_element_label = "available pick eliminated"
							glyphicon = "glyphicon glyphicon-ok"
						else
							status = "eliminated"
							label = "NOT PICKED LAST ROUND"
							action_element_label = "available pick eliminated"
							glyphicon = ""
						end
					end
				end
			end
			round_contestants_data_collection[contestant_id] = {
				:status => status,
				:label => label,
				:i_label => i_label,
				:action => action_element_label,
				:glyphicon => glyphicon
			}
		end
		# ==== END CONTESTANT DATA ==== #
		
		# ==== ROUND DATA ==== #
		@round_data_collection = Hash.new
		round_status = ""
		count_difference = current_round.contestants.count - current_round.episode.expected_survivors
		
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

		@round_data_collection = {
			:round_contestants_data_collection => round_contestants_data_collection,
			:round_status => round_status,
			:count_difference => count_difference,
			:round_action => round_action,
			:round_message => get_round_message(current_round, round_status, count_difference, round_action),
			:prev_round_id => previous_round_id,
			:next_round_id => next_round_id
		}

		# ==== END ROUND DATA ==== #

		return @round_data_collection
	end

	def process_and_return(contestant_id, round_id, action)
		contestant = Contestant.find(contestant_id) if contestant_id != nil
		@active_round = Round.includes(:league, :contestants).find(round_id)
		@league = @active_round.league
		@season = @league.season
		@contestants = @season.contestants.order(name: :asc)
		
		static_data_package = get_static_data(@league.id)

		case action
		when "add"
			@active_round.contestants << contestant unless @active_round.contestants.include? contestant
		when "remove"
			cascade_delete_contestant(contestant_id, round_id, static_data_package[:rounds_ids_collection])
		when "bulk_add"
			bulk_add_contestants(round_id, static_data_package[:upcoming_rounds_ids])
		end		

		round_data_package = get_round_data(round_id, @league.id, action)	
		@rounds_ids_collection = static_data_package[:rounds_ids_collection]
		@episodes_ids_collection = static_data_package[:episodes_ids_collection]
		@contestants_ids_collection = static_data_package[:contestants_ids_collection]
		@upcoming_rounds_ids = static_data_package[:upcoming_rounds_ids]

		action_package = get_round_actions(@active_round, static_data_package, round_data_package)
	
		@active_round_index = action_package[:active_round_index]
		@active_round_title = action_package[:active_round_title]
		@previous_button = action_package[:previous_button]
		@next_button = action_package[:next_button]
		@previous_round_id = action_package[:previous_round_id]
		@next_round_id = action_package[:next_round_id]

		respond_to do |format|
			format.html { 
				render partial: "current_bracket", :remote => true 
			}
		end
	end

	def get_episode_action(round_id, round_status, rounds_ids_collection)
		@episodes_action = []
		current_round = Round.find(round_id)
		rounds_ids_collection[current_round.user_id].each_with_index do |id, index|
			@episodes_action[index] = [id, index + 1, "Episode #{index + 1}", ""]
			@episodes_action[index][3] = round_status if id == round_id
			round = Round.find(id)
			if round.episode.aired == false
				if round.id == round_id
					@episodes_action[index].push("btn btn-block btn-sm btn-default btn-primary selected")
				else
					@episodes_action[index].push("btn btn-block btn-sm btn-default")
				end
			else
				@episodes_action[index].push("btn btn-block btn-sm btn-default disabled")
			end
		end
		return @episodes_action
	end

	def get_round_message(round, status, count_difference, action)
		round_message = Hash.new

		case status
		when "alert-success"
			round_message = {
				:contentHero => "You're done with this round!",
				:contentSupport => {
					:a => "Click the highlighted button to proceed.",
					:b => "You can update your pick anytime before the league's deadline on"
				},
				:contentCountDifference => nil,
				:contentDate => "#{@league.draft_deadline.strftime("%D")}."
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
						:a => "You have too many contestants moving on to the next episode. Remove",
						:b => "before moving on to the next episode."
					},
					:contentCountDifference => count_difference,
					:contentDate => nil
				}
			elsif action == "remove"
				round_message = {
					:contentHero => "More must be eliminated.",
					:contentSupport => {
						:a => "Discard",
						:b => "you think will get eliminated during this episode."
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
						:b => "you think will make it through to the next episode."
					},
					:contentCountDifference => count_difference.abs,
					:contentDate => nil
				}	
			elsif action == "add"
				round_message = {
					:contentHero => "Who else will make it?",
					:contentSupport => {
						:a => "Select",
						:b => "you think will make it through to the next episode."
					},
					:contentCountDifference => count_difference.abs,
					:contentDate => nil
				}
			elsif action == "remove"
				round_message = {
					:contentHero => "There's still room in this round.",
					:contentSupport => {
						:a => "Select",
						:b => "you think will make it through to the next episode."
					},
					:contentCountDifference => count_difference.abs,
					:contentDate => nil
				}
			end
		end		
	end

	def get_round_actions(round, static_data_pack, round_data_collection)
		action_package = Hash.new 
		active_round_index = static_data_pack[:rounds_ids_collection][round.user_id].index(round.id)
		active_round_title = ""
		previous_button = []
		next_button = []
		previous_button[0] = "Previous"
		previous_button[1] = "btn-default btn-xs round-toggle previous-button"
		previous_button[2] = "previous"
		next_button[0] = "Next"
		next_button[1] = "btn-default btn-xs round-toggle next-button disabled"
		next_button[2] = "next"
		previous_round_id = nil
		next_round_id = nil	

		if round_data_collection[:round_status] == "alert-success"
			next_button[1] = "btn-primary btn-xs round-toggle next-button boogo"
		elsif round_data_collection[:round_status] == "alert-warning"
			next_button[1] = "btn-default btn-xs round-toggle next-button disabled"
		else
			next_button[1] = "btn-default btn-xs round-toggle next-button disabled"	
		end	

		if round.id == static_data_pack[:rounds_ids_collection][round.user_id].first
			active_round_title = "Round #{active_round_index + 1}"
			previous_button[1] = "btn-default btn-xs round-toggle previous-button disabled"
			previous_round_id = nil
			next_round_id = static_data_pack[:rounds_ids_collection][round.user_id][1]
		elsif	round.id == static_data_pack[:rounds_ids_collection][round.user_id].last
			active_round_title = "Final Round"
			previous_button[1] = "btn-default btn-xs round-toggle previous-button"
			next_button[0] = "Finish"
			next_button[2] = "finish"
			previous_round_id = static_data_pack[:rounds_ids_collection][round.user_id][-2]
			next_round_id = nil
		else
			active_round_title = "Round #{active_round_index + 1}"
			previous_round_id = static_data_pack[:rounds_ids_collection][round.user_id][active_round_index - 1]
			next_round_id = static_data_pack[:rounds_ids_collection][round.user_id][active_round_index + 1]
		end


		action_package[:active_round_index] = active_round_index
		action_package[:active_round_title] = active_round_title
		action_package[:previous_button] = previous_button
		action_package[:next_button] = next_button
		action_package[:previous_round_id] = previous_round_id
		action_package[:next_round_id] = next_round_id

		return action_package
	end

end
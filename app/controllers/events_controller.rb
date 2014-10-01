class EventsController < ApplicationController
	def index
		# get data for dynamic drop-down
		@shows = Show.all
		@seasons = Season.where("show_id = ?", Show.first.id)

		# all events
		@events_all = Event.all
		@events_info_table = {}
		@events_all.each do |event|
			season = event.episode.season
			episode = event.episode
			contestant = event.contestant.name
			description = generate_half_sentence(event.scheme.description)
			pts = event.scheme.points_asgn
			event_description = contestant + description
			event_data = {
				:season => season,
				:episode => episode,
				:scheme => event_description,
				:points_assigned => pts}
			@events_info_table[event.id] = event_data
		end

		export_show_season_lists
	end

	def new
		@event = Event.new
	end

	def create
		#====== check for bad entry ======#
		event_show = Show.find(params[:point_entry][:show_select])
		event_season = Season.find(params[:point_entry][:season_select])
		event_contestant = Contestant.find(params[:point_entry][:contestant_select])
		event_scheme = Event.find(params[:point_entry][:scheme_select])
		if event_season.show_id != event_show.id
			#---- if selected season doesn't belong to the show
			flash[:notice] = "Invalid entry: selected season does not belong to the selected show."
			flash[:color] = "invalid"
			render :new
		elsif event_season.contestants.exclude? event_contestant
			#---- if selected contestant does not belong to the season
			flash[:notice] = "Invalid entry: selected contestant does not belong to the selected season."
			flash[:color] = "invalid"
			render :new
		else
			#---- if all is good
			new_params = {
				:contestant_id => params[:point_entry][:contestant_select], 
				:episode_id => params[:point_entry][:episode_select], 
				:scheme_id => params[:point_entry][:scheme_select]
			}

			@event = Event.new new_params

			if @event && @event.save
				redirect_to events_path
			else
				raise
				render :new
			end
		end

	end

	def update
		
	end

	def delete
		raise "got to delete"
	end

	def display
		@season = Season.find_by("id = ?", params[:point_entry][:season_id])	
	end

	def get_seasons
		@seasons = Season.where("show_id = ?", params[:show_id])
		respond_to do |format|
			format.js
		end
	end

	private

	def event_param
		params.require(:events).permit(:contestant_id, :episode_id, :scheme_id)
	end

	def generate_half_sentence(string)
		string.gsub!("Contestant", "")
		return string
	end

	# Generate
	def points_by_season(season_id)
		episodes_season_list = Episode.where(season_id: season_id)
		@events_all.where(episode_id: season_id)
	end
end

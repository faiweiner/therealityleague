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
	end

	def new
		@event = Event.new
	end

	def create
		#====== check for bad entry ======#
		event_show = Show.find(params[:show_list])
		event_season = Season.find(params[:season_list])
		event_episode = Episode.find(params[:event][:episode_id])
		event_contestant = Contestant.find(params[:event][:contestant_id])
		event_scheme = Scheme.find(params[:event][:scheme_id])


		
		@event = Event.new event_param[:event]
		raise 

		if @event && @event.save
			redirect_to events_path
		else
			raise
			render :new
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

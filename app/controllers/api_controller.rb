class APIController < ApplicationController
	before_action :set_current_user, :get_shows, :new_message
	# for AJAX requests only 
	def shows_list
		shows_list = Show.all
		render json: {
			showsList: shows_list,
			status: 201
		}
	end

	# for AJAX requests only 
	def seasons_list
		seasons = Season.where(:expired => false, :show_id => params[:show_list])
		seasons_list = []
		seasons.each do |season|
			season = { 
				:name => season.name,
				:id => season.id,
				:showId => season.show.id,
				:contestantCount => season.contestants.count,
				:premiereDate => season.premiere_date
			}
			seasons_list.push season
		end

		respond_to do |format|
			format.js {
				render :json => {
					:seasonsList => seasons_list
				}
			}
		end
	end

	# for AJAX requests only 
	def episodes_list
		episodes = Episode.where(:season_id => params[:season_id])
		episodes_list = []
		episodes.each_with_index do |episode, index|
			episode = { 
				:name => "Episode #{index+1}",
				:id => episode.id,
				:airDate => episode.air_date.strftime("%m/%d/%Y"),
				:seasonId => episode.season.id
			}
			episodes_list.push episode
		end
		respond_to do |format|
			format.js {
				render :json => {
					:episodesList => episodes_list
				}
			}
		end
	end

	# for AJAX requests only 
	def contestants_list
		contestants = Contestant.where(:season_id => params[:season_id]).order(:name)
		contestants_list = []
		contestants.each do |contestant|
			contestant = {
				:name => contestant.name,
				:id => contestant.id,
				:status => contestant.status_on_show,
				:present => contestant.present
			}
			contestants_list.push contestant
		end	
		respond_to do |format|
			format.js {
				render :json => {
					:contestantsList => contestants_list
				}
			}
		end
	end

	# for AJAX requests only
	def schemes_list
		schemes = Scheme.where(:show_id => params[:show_id])
		schemes_list = []
		scheme_types_list = []
		schemes.each do |scheme|
			scheme_types_list.push scheme.type
			scheme = {
				:id => scheme.id,
				:description => scheme.description,
				:schemeType => scheme.type
			}
			schemes_list.push scheme
		end
		scheme_types_list.uniq!
		respond_to do |format|
			format.js {
				render :json => {
					:schemesList => schemes_list,
					:schemeTypes => scheme_types_list
				}
			}
		end
	end

end
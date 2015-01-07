class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	before_action :set_current_user, :get_shows, :new_message
	
	def export_show_list
		@export_show_list = Show.all
		respond_to do |format|
			format.js { 		
				render :json => {
					:exportShows => @export_show_list
				} 
			}
		end
	end

	def export_season_list
		@export_season_list = Season.where(expired: false, show_id: params[:show_list]).order(name: :asc)
		respond_to do |format|
			format.js { 		
				render :json => {
					:exportSeasons => @export_season_list
				} 
			}
		end
	end


	# for AJAX requests only 
	def shows_list
		shows_list = Show.all
		respond_to do |format|
			format.js {
				render :json => {
					:showsList => shows_list
				} 
			}
		end
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
		episodes = Episode.where(:season_id => params[:season_list])
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
		contestants = Contestant.where(:season_id => params[:season_list]).order(:name)
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
		schemes = Scheme.where(:show_id => params[:show_list]).order(:type, :id)
		schemes_list = []
		schemes.each_with_index do |scheme, index|
			scheme = {
				:description => scheme.description,
				:type => scheme.type,
				:id => scheme.id
			}
			schemes_list.push scheme
		end
		respond_to do |format|
			format.js {
				render :json => {
					:schemesList => schemes_list
				}
			}
		end		
	end

	def new_message
		@message = Message.new	
		set_current_user
	end

	private 

	def regex_validation(query)
		if /^\s*$/.match(query)												# 1. Empty search queries (invalid)
			return "empty"
		elsif query.length == 10 && !query[/\H/]			# 2. League key
			return "league_key"
		elsif /^\s+[a-zA-Z]/.match(query) || /\S+\b+/.match(query)
			query = query.strip
			if Show.get_show_names.include? query && Show.search_show(query).any?
				return show = Show.search_show(query)
			else
				return "no match for show"
			end
		else
			return "no match"
		end
	end

	def get_shows
		@shows = Show.all
	end

	def check_if_logged_in
		if @current_user.nil?
			session[:user_id] = "unassigned"
			flash[:notice] = "Please sign in to proceed." # FIXME to add a URL tracker for back-tracking
			flash[:color] = "invalid"
			redirect_to(login_path) 
		end
	end
	
	def set_current_user
		if session[:user_id].present? 
			@current_user = User.where(:id => session[:user_id]).first
		end

		if @current_user.nil?
			session[:user_id] = nil
		end
	end

	def save_login_state
		return false if session[:user_id].present?
	end

	def current_user
		@current_user ||= User.where(session[:user_id]) if session[:user_id]
	end

	def admin?
		user = User.find(@current_user.id)
		return true if user.admin == true
	end

	def render_admin
		if @current_user.admin?
			render layout: "admin"
		end
	end

	def check_if_admin
		if @current_user == nil || @current_user.admin? == false
			redirect_to root_path
		end
	end

	helper_method :current_user, :regex_validation, :render_admin
end

class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	before_action :set_current_user, :get_shows, :new_message, :get_facebook_app_id

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
		season = Season.find(params[:season_id])
		episode_id = params[:episode_id]
		contestants = season.contestants.order(:name)
		contestants_list = []
		contestants.each do |contestant|
			status = Status.where(contestant_id: contestant.id, season_id: season.id).first
			if status.present === false
				if status.eliminated_episode_id < episode_id.to_i
					season_status = "eliminated"
				end
			else
				season_status = ""
			end
			contestant = {
				:name => contestant.name,
				:id => contestant.id,
				:status => season_status
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

	def new_message
		@message = Message.new	
		set_current_user
	end

	def get_schemes(show)
		show_schemes = Scheme.where(show_id: show.id)
		if show_schemes.any?
			show_schemes.each do |scheme|
				unless show.schemes.include? scheme
					show.schemes << scheme
				end
			end
		end
		rules = show.schemes
		rule_types = rules.pluck(:type).uniq.sort
		rules_package = Hash.new
		rule_types.each do |type|
			rules_package[type] = rules.where(type: type).order(points_asgn: :asc)
		end
		return rules_package
	end

	def get_filtered_schemes(show, type)
		rules = show.schemes.where(type: type)
		return rules
	end

	def get_scheme_types(show)
		types = show.schemes.pluck(:type).uniq!.sort
		return types
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
			flash[:color] = "alert-warning"
			redirect_to(login_path) 
		end
	end
	
	def check_if_admin
		return false if User.where(id: session[:user_id]).first.admin == true
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

	def get_facebook_app_id
		facebook_app_id = Rails.application.secrets.facebook_app_id
	end

	def admin?
		user = User.find(@current_user.id)
		return true if user.admin == true
	end

	def render_admin
		if @current_user && @current_user.admin?
			render layout: "admin"
		end
	end

	def check_if_admin
		if @current_user.nil? || @current_user.admin? == false
			flash[:notice] = "You are not authorized to access the administrative page."
			flash[:color] = "alert-danger"
			redirect_to root_path
		end
	end

	helper_method :current_user, :regex_validation, :render_admin
end

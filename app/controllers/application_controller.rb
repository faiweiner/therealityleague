class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	before_action :set_current_user, :get_shows
	
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
		@export_season_list = Season.where(expired: false)
		respond_to do |format|
			format.js { 		
				render :json => {
					:exportSeasons => @export_season_list.where(show_id: params[:show_list])
				} 
			}
		end
	end

	def shows_list
		shows_list = Show.all
		respond_to do |format|
			format.js {
				render :json => {
					:exportShows => shows_list
				} 
			}
		end
	end

	def seasons_list
		seasons = Season.where(:expired => false, :show_id => params[:showId])
		seasons_list = []
		seasons.each do |season|
			season = { :name => season.name,
				:id => season.id,
				:showId => season.show.id
			}
			seasons_list.push season
		end

		respond_to do |format|
			format.js {
				render :json => {
					:exportSeasons => seasons_list
				}
			}
		end
	end

	def episodes_list
		episodes = Episode.where(:season_id => params[:seasonId])
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

	def check_if_admin
		if @current_user == nil || @current_user.admin? == false
			redirect_to root_path
		end
	end

	helper_method :current_user, :regex_validation
end

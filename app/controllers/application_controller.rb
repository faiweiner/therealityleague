class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	
	before_action :set_current_user, :get_shows
	before_action :save_login_state, :only => [:new, :login_attempt]

	private 

	def featured_seasons
		@featured_seasons = Season.top_three
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
		if session[:user_id].present?
			return false
		else
			return true
		end
	end

	def current_user
		@current_user ||= User.where(session[:user_id]) if session[:user_id]
	end

	def admin?
		user = User.find(@current_user.id)
		return true if user.admin == true
	end

	def check_if_admin
		if @current_user && @current_user.admin? == false
			redirect_to root_path
		end
	end

	def bar
		return "hello"
	end
	
	def export_show_season_lists
		@export_show_list = Show.all
		@export_season_list = Season.where(expired: false)

		respond_to do |format|
			format.html
			format.js { 		
				render :json => {
					:exportShows => @export_show_list,
					:exportSeasons => @export_season_list.where(show_id: params[:show_list])
				} 
			}
		end

	end

	helper_method :current_user
end

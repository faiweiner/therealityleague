class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :set_current_user
  before_action :save_login_state, :only => [:new, :login_attempt]

  private 

  def featured_shows
    @featured_shows = Show.top_three
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
  
  helper_method :current_user
end

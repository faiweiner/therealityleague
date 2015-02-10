class UsersController < ApplicationController
	
	before_action :assign_user, :only => [:edit, :link_fb, :update, :show]
	before_action :check_if_logged_in, :except => [:new, :create]
	before_action :save_login_state, :only => [:new, :create]

	def index
		@users = User.all
	end
	
	def new
		@user = User.new
		@header = "Sign Up"
	end

	def create
		@user = User.new user_params
		if @user.save
			session[:user_id] = @user.id
			flash[:notice] = "You've successfully signed up."
			# Once someone signs up, they currently need to log in. Better to have automatically log-in?
			flash[:color] = "alert-success"
			redirect_to root_path
		else
			flash[:notice] = "Unsuccessful sign up, please try again."
			flash[:color] = "alert-warning"
			render :new
		end
	end

	def edit
		# assign @user to match with View
		if @user.admin?
			@header = "Site Master"
		else
			@header = "Edit User"
		end
	end

	def link_fb
		# assign @user to match with View
		raise
		if @user.update(fb_params)
		else
		end
	end

	def unlink_fb
		raise
	end

	def update
		# assign @user to match with View
		if @user.update(user_params)
			flash[:notice] = "You've successfully updated."
			flash[:color] = "alert-success"		
			redirect_to user_path
		else
			flash[:notice] = "Something went wrong, try again."
			flash[:color] = "alert-warning"		
			redirect_to edit_user_path(@user.id)
		end
	end

	def show
		# assign @user to match with View
		@user_account = {}
		@user_account[:facebook] = {}
		@user_account[:username] = @user.username
		@user_account[:email] = @user.email
		if @user.fb_id.present?
			@user_account[:facebook][:label] = "Connected"
			@user_account[:facebook][:path] = unlink_fb_path(@user.id)
			@user_account[:facebook][:link_id] = ""
			@user_account[:facebook][:method] = ""
		else
			@user_account[:facebook][:label] = "Not connected"
			@user_account[:facebook][:path] = link_fb_path(@user.id)
			@user_account[:facebook][:link_id] = "#fb-login-button"
			@user_account[:facebook][:method] = "POST"
		end
	end
	
	private

	def assign_user
		@user = @current_user
	end

	def user_params
		params.require(:user).permit(:email, :username, :avatar, :password, :password_confirmation)
	end
		
	def fb_params
		params.require(:user).permit(:fb_id, :email, :username, :oauth_token, :oauth_expires_at, :timezone)
	end
		
	def check_if_admin
		redirect_to(root_path) unless @current_user.is_admin?
	end
end

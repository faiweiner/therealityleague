class UsersController < ApplicationController
	
	before_action :check_if_logged_in, :except => [:new, :create]
	before_action :save_login_state, :only => [:new, :create]

	def index
		@users = User.all
	end
	
	def new
		@user = User.new
	end

	def create
		@user = User.new user_params
		if @user.save
			session[:user_id] = @user.id
			flash[:notice] = "You've successfully signed up."
			# Once someone signs up, they currently need to log in. Better to have automatically log-in?
			flash[:color] = "valid"
			redirect_to root_path
		else
			flash[:notice] = "Unsuccessful sign up, please try again."
			flash[:color] = "invalid"
			render :new
		end
	end

	def edit
		@user = @current_user
	end

	def update
		@user = @current_user
		if @current_user.update(user_params)
			flash[:notice] = "You've successfully updated."
			flash[:color] = "valid"		
			redirect_to user_path
		else
			flash[:notice] = "Something went wrong, try again."
			flash[:color] = "invalid"		
			redirect_to edit_user_path(@current_user.id)
		end
	end

	def show
		
	end
	
	private

	def user_params
		params.require(:user).permit(:email, :username, :avatar, :password, :password_confirmation)
	end

	def find_current_user
		User.find(@current_user.id)
	end
	
	def check_if_admin
		redirect_to(root_path) unless @current_user.is_admin?
	end
end

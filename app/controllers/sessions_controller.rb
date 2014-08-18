class SessionsController	< ApplicationController
	def new
		# Sign-in form
	end

	def fb_login_attempt
		
	end

	def login_attempt
		user = User.find_by(:username => params[:username])
		if user.present? && user.authenticate(params[:password])
			session[:user_id] = user.user_id
			flash[:notice] = "Welcome back!"
			redirect_to user_path(user.user_id)
		else
			flash[:notice] = "Invalid login. Please try again."
      redirect_to login_path
		end
	end

	def logout
		session[:user_id] = nil
		redirect_to root_path
	end
end
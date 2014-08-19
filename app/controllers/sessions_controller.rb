class SessionsController	< ApplicationController
	def new
		# Sign-in form
	end

	def fb_login_attempt
		
	end

	def login_attempt
		user = User.find_by(:email => params[:email])
		if user.present? && user.authenticate(params[:password])
			session[:user_id] = user.id
			flash[:notice] = "Welcome back!"
			if user.leagues.count > 0
				redirect_to leagues_path
			else
				redirect_to root_path
			end
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
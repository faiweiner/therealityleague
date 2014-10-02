class SessionsController	< ApplicationController
	before_action :save_login_state, :only => [:new, :login_attempt]
	
	def new
		# view renders Sign-in (Session) form
	end

	def login_attempt
		user = User.find_by(:email => params[:email])
		if user.present? && user.authenticate(params[:password])
			session[:user_id] = user.id
			if user.admin?
				redirect_to admin_path
			elsif	user.leagues.count > 0
				flash[:notice] = "Welcome back, #{@current_user}!"
				flash[:color] = "valid"
				redirect_to leagues_path
			else
				flash[:notice] = "Welcome!"	
				flash[:color] = "valid"
				redirect_to root_path
			end
		else
			flash[:notice] = "Invalid login. Please try again."
			flash[:color] = "invalid"
      redirect_to login_path
		end
	end

	def logout
		session[:user_id] = nil
		redirect_to root_path
	end
end
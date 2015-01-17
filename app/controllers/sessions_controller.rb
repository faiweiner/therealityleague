class SessionsController	< ApplicationController
	before_action :save_login_state, :only => [:new, :login_attempt]
	
	def new
		# view renders Sign-in (Session) form
	end

	def login_attempt
		user = User.find_by(:email => params[:email])
		if user.present? && user.authenticate(params[:password])
			user.save
			session[:user_id] = user.id
			flash[:button] = []
			if user.leagues.any?
				flash[:notice] = "Welcome back, #{user.username}!"
				flash[:color] = "alert-success"
				redirect_to leagues_path
			elsif user.leagues.empty?
				flash[:notice] = "Welcome back, #{user.username}!"
				flash[:subtext] = "You currently don't have a league - would you like to join one?"	
				flash[:color] = "success"
				flash[:button][0] = ["Join a League", "/leagues/search", "btn btn-sm btn-default"]
				redirect_to root_path
			else
				flash[:notice] = "Welcome!"
				flash[:color] = "alert-success"
			end
		else
			flash[:notice] = "Invalid login. Please try again."
			flash[:color] = "alert-warning"
      redirect_to login_path
		end
	end

	def logout
		session[:user_id] = nil
		redirect_to root_path
	end
end
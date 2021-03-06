class SessionsController	< ApplicationController
	before_action :save_login_state, :only => [:new, :login_attempt]
	
	def new
		# view renders Sign-in (Session) form
		@header = "Sign In"
	end

	def facebook_login
		user = User.find_by(:oauth_id => params[:user][:oauth_id], :email => params[:user][:email])
		if user.present?
			session[:user_id] = user.id
			respond_to do |format|
				format.json {
					render :json => {
						:url => leagues_path
					}
				}
			end
		else
			redirect_to login_path
		end
	end
	
	def login_attempt
		user = User.find_by(:email => params[:email].downcase)
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
				redirect_to root_path
			end
		elsif user.nil?
			raise
		else
			flash[:notice] = "Invalid login. Please try again."
			flash[:color] = "alert-warning"
      redirect_to login_path
		end
	end

	def logout
		session[:user_id] = nil
		flash[:notice] = nil
		flash[:color] = nil
		redirect_to root_path
	end
end
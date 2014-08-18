class LeaguesController < ApplicationController

	def index
		@leagues = League.all #FIXME!
	end
	def new
		@league = League.new 
	end

	def create
		@league = League.new league_params
		if @league.save
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

	def show
		
	end
	def search
		@public_leagues = League.where(:public_access => true)
	end

	def results
	end

	private

	def league_params
    params.require(:league).permit(:name, :commissioner_id, :show_id, :public_access, :draft_type, :scoring_system, :league_key, :league_password)
  end
end

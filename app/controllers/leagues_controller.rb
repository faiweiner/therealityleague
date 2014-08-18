class LeaguesController < ApplicationController

	def index
		@leagues = League.all #FIXME!
	end
	def new
		@league = League.new 
		@shows = Show.all
	end

	def create
		@league = League.new league_params
		if @league.save

			# get customized text based on type
			@access_type = nil
			if @league.public_access == true
				@access_type = "public"
			else
				@access_type = "private"
			end
			flash[:notice] = "You've successfully created a #{access_type} league!"
			# Once someone signs up, they currently need to log in. Better to have automatically log-in?
			flash[:color] = "valid"
			redirect_to league_path(League.last)
		else
			flash[:notice] = "Something went wrong and we were unable to save your league"
			flash[:color] = "invalid"
			render :new
		end
	end

	def show
		@league = League.last
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

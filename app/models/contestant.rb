# == Schema Information
#
# Table name: contestants
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  season_id   :integer
#  image       :string(255)
#  age         :integer
#  gender      :string(255)
#  occupation  :string(255)
#  description :text
#  source      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Contestant < ActiveRecord::Base
	has_and_belongs_to_many :rosters, inverse_of: :contestants
	has_and_belongs_to_many :rounds, inverse_of: :contestants
	
	has_many :statuses
	has_many :seasons, through: :statuses
	has_many :events
	has_many :episodes, through: :events
	has_many :schemes, through: :events

	validates :name, :presence => true, :on => :create

	before_destroy { rosters.clear }

	def self.select_gender
		@gender_list = ["Male", "Female", "N/A"]
	end

	def self.select_status
		@status_list = ["Present", "Eliminated", "Brought Back"]
	end

	def self.select_contestant
		# This model method is for populating Create League's drop-down menu
		@contestants_list = Contestant.where(present: true).each.map {|c| [c.name, c.id] }
		@contestants_list.unshift(["Select a contestant", nil])
	end

	def self.list_contestants(episode_id)
		@contestants_list = Episode.find(episode_id).season.contestants
	end

	def calculate_points_per_episode(episode_id)
		Event.joins(:scheme).where(contestant_id: self.id, episode_id: episode_id).sum("schemes.points_asgn")
	end

	def calculate_points_per_round(round_id)
		round = Round.includes(:episode).find(round_id)
		episode = round.episode
		Event.where(contestant_id: self.id, episode_id: episode.id).sum("points_earned")
	end

	def create_status(season)
		season.contestants << self unless season.contestants.include? self
	end

	def check_status(season)
		if contestant.season_id?
			season = Season.find(id: contestant.season_id)
			season.contestants << contestant unless season.contestants.include? contestant
			contestant.update(season_id: nil)
			contestant.save
		end	
	end

	def calculate_total_points		# takes one contestant of a roster to get his/her total score
		Event.where(contestant_id: self.id).sum("points_earned")
	end

	private


end

# == Schema Information
#
# Table name: contestants
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  season_id      :integer
#  image          :string(255)
#  age            :integer
#  gender         :string(255)
#  occupation     :string(255)
#  description    :text
#  status_on_show :string(255)
#  present        :boolean          default(TRUE)
#  episode_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Contestant < ActiveRecord::Base
	belongs_to :season
	has_and_belongs_to_many :rosters, inverse_of: :contestants
	has_and_belongs_to_many :rounds, inverse_of: :contestants
	before_destroy { rosters.clear }
	
	has_many :points
	has_many :episodes, through: :points
	has_many :events, through: :points

	validates :name, :presence => true, :on => :create
	validates :season_id, :presence => true, :on => :create


	def calculate_points_per_episode(episode_id)
		Point.joins(:event).where(contestant_id: self.id, episode_id: episode_id).sum("events.points_asgn")
	end

	def calculate_points_per_round(round_id)
		round = Round.find(round_id)
		episode = Episode.find(round.episode_id)
		Point.joins(:event).where(contestant_id: self.id, episode_id: episode.id).sum("events.points_asgn")
	end

	def calculate_total_points		# takes one contestant of a roster to get his/her total score
		Point.joins(:event).where(contestant_id: self.id).sum("events.points_asgn")
	end

	def status
		return "(eliminated)" if self.present == false
	end
end

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
	before_destroy { rosters.clear }
	has_and_belongs_to_many :rounds, inverse_of: :contestants
	
	has_many :events
	has_many :episodes, through: :events
	has_many :schemes, through: :events

	validates :name, :presence => true, :on => :create
	validates :season_id, :presence => true, :on => :create

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

	def calculate_points_per_episode(episode_id)
		Event.joins(:scheme).where(contestant_id: self.id, episode_id: episode_id).sum("schemes.points_asgn")
	end

	def calculate_points_per_round(round_id)
		round = Round.find(round_id)
		episode = Episode.find(round.episode_id)
		Event.joins(:scheme).where(contestant_id: self.id, episode_id: episode.id).sum("schemes.points_asgn")
	end

	def calculate_total_points		# takes one contestant of a roster to get his/her total score
		Event.joins(:scheme).where(contestant_id: self.id).sum("schemes.points_asgn")
	end

	def status
		return "(eliminated)" if self.present == false
	end
end

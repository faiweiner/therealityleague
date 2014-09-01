# == Schema Information
#
# Table name: episodes
#
#  id         :integer          not null, primary key
#  season_id  :integer
#  air_date   :datetime
#  created_at :datetime
#  updated_at :datetime
#

class Episode < ActiveRecord::Base
	belongs_to :season
	has_many :rounds

	has_many :points
	has_many :contestants, through: :points
	has_many :events, through: :points

	validates :season_id, :presence => true
	validates :air_date, :presence => true
end

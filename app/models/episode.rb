# == Schema Information
#
# Table name: episodes
#
#  id         :integer          not null, primary key
#  show_id    :integer
#  air_date   :datetime
#  created_at :datetime
#  updated_at :datetime
#

class Episode < ActiveRecord::Base
	belongs_to :show
	has_many :rounds

	has_many :points
	has_many :contestants, through: :points
	has_many :events, through: :points

	validates :show_id, :presence => true
	validates :air_date, :presence => true
end

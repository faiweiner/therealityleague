# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  show_id     :integer
#  event       :string(255)
#  points_asgn :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Event < ActiveRecord::Base
	belongs_to :show, inverse_of: :events

	has_many :points
	has_many :contestants, through: :points
	has_many :episodes, through: :points
end

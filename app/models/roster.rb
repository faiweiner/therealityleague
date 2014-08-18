# == Schema Information
#
# Table name: rosters
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  league_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Roster < ActiveRecord::Base
	belongs_to :user, inverse_of: :rosters
	belongs_to :league, through: :users
	has_and_belongs_to_many :contestants, inverse_of: :rosters

	validates :user_id, :presence => true
	validates :league_id, :presence => true

end

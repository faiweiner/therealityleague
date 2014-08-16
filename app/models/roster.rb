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
	belongs_to :user
	belongs_to :league
	has_and_belongs_to_many :contestants
end

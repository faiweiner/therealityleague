# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  episode_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Round < ActiveRecord::Base
	belongs_to :league
	belongs_to :episode
end

def pts_for_user
	
end

# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  episode_id :integer
#

class Round < ActiveRecord::Base
	belongs_to :league, inverse_of: :rounds
	belongs_to :episode, inverse_of: :rounds
end

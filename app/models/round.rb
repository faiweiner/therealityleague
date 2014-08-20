# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  episode_id :integer
#

class Round < ActiveRecord::Base
	belongs_to :league
	belongs_to :episode
	has_many :scores, inverse_of: :round, :dependent => :destroy
end

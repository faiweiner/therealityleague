# == Schema Information
#
# Table name: scores
#
#  id            :integer          not null, primary key
#  round_id      :integer
#  contestant_id :integer
#  event         :string(255)
#  points        :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Score < ActiveRecord::Base
	belongs_to :round, inverse_of: :scores
	has_one :contestant, inverse_of: :scores
end

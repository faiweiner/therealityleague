# == Schema Information
#
# Table name: points
#
#  id           :integer          not null, primary key
#  type         :string(255)
#  franchise_id :integer
#  event        :string(255)
#  points       :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Point < ActiveRecord::Base
	belongs_to :franchise, inverse_of: :points
	has_and_belongs_to_many :contestants, inverse_of: :points
end


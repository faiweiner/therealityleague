# == Schema Information
#
# Table name: franchises
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Franchise < ActiveRecord::Base
	has_many :shows, inverse_of: :franchise, dependent: :destroy
	has_many :events, inverse_of: :franchise, dependent: :destroy
	has_many :episodes, through: :shows
	has_many :points, through: :events
end

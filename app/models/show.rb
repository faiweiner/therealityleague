# == Schema Information
#
# Table name: shows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  image      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Show < ActiveRecord::Base
	has_many :seasons, inverse_of: :show, dependent: :destroy
	has_many :events, inverse_of: :show, dependent: :destroy
	has_many :episodes, through: :seasons
	has_many :points, through: :events
end

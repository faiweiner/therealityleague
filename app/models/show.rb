# == Schema Information
#
# Table name: shows
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  premiere_date    :datetime
#  draft_close_date :datetime
#  country_origin   :string(255)
#  type             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  description      :string(255)
#

class Show < ActiveRecord::Base
	has_many :leagues
	has_many :contestants
	has_many :episodes
	has_many :contestants
	# belongs_to :scoring
end

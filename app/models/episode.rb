# == Schema Information
#
# Table name: episodes
#
#  id       :integer          not null, primary key
#  show_id  :integer
#  air_date :datetime
#

class Episode < ActiveRecord::Base
	belongs_to :show, inverse_of: :episodes
	has_many :rounds, inverse_of: :episode

	validates :show_id, :presence => true
	validates :air_date, :presence => true
end

# == Schema Information
#
# Table name: episodes
#
#  id       :integer          not null, primary key
#  show_id  :integer
#  air_date :datetime
#

class Episode < ActiveRecord::Base
	belongs_to :show
	has_many :rounds

	validates :show_id, :presence => true
	validates :air_date, :presence => true
end

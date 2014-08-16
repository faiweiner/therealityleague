# == Schema Information
#
# Table name: episodes
#
#  id      :integer          not null, primary key
#  show_id :integer
#

class Episode < ActiveRecord::Base
	belongs_to :show
	has_many :rounds
end

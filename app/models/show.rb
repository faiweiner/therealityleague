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
	# belongs_to :score

	validates :name, :presence => true, :on => :create
	validates :premiere_date, :presence => true, :on => :create
	validates :draft_close_date, :presence => true, :on => :create
	# FIXME! put in a check for draft_close_date to be 

	private

	def self.check_draft_date
		self.draft_close_date.change(day: 5)
	end
end

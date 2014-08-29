# == Schema Information
#
# Table name: contestants
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  show_id        :integer
#  image          :string(255)
#  age            :integer
#  gender         :string(255)
#  occupation     :string(255)
#  description    :text
#  status_on_show :string(255)
#  present        :boolean          default(TRUE)
#  episode_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Contestant < ActiveRecord::Base
	belongs_to :show
	has_and_belongs_to_many :rosters, inverse_of: :contestants
	before_destroy { rosters.clear }
	
	has_many :points
	has_many :episodes, through: :points
	has_many :events, through: :points

	validates :name, :presence => true, :on => :create
	validates :show_id, :presence => true, :on => :create
end

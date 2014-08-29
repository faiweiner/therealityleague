# == Schema Information
#
# Table name: franchises
#
#  id   :integer          not null, primary key
#  name :string(255)
#

class Franchise < ActiveRecord::Base
	has_many :shows, inverse_of: :franchise, dependent: :destroy
	has_many :points, inverse_of: :franchise, dependent: :destroy
end

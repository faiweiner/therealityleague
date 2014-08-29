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

class Survival < Point
end

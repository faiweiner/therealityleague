# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  type         :string(255)
#  franchise_id :integer
#  event        :string(255)
#  points_asgn  :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Survival < Event
end

# == Schema Information
#
# Table name: schemas
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  show_id     :integer
#  description :string(255)
#  points_asgn :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Survival < Schema
end

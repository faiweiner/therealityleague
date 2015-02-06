# == Schema Information
#
# Table name: schemes
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  description :string(255)
#  points_asgn :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Extracurricular < Scheme
	def self.model_name
		Scheme.model_name
	end
end

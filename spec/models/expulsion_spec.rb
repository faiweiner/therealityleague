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

require 'rails_helper'

RSpec.describe Expulsion, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

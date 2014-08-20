# == Schema Information
#
# Table name: scores
#
#  id            :integer          not null, primary key
#  round_id      :integer
#  contestant_id :integer
#  event         :string(255)
#  points        :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'rails_helper'

RSpec.describe Score, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

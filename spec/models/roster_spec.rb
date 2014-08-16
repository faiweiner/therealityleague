# == Schema Information
#
# Table name: rosters
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  league_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Roster, :type => :model do
	it { is_expected.to belong_to(:user) }
	it { is_expected.to belong_to(:league) }
	it { is_expected.to have_and_belong_to_many(:contestants) }
end

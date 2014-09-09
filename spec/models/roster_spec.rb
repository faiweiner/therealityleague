# == Schema Information
#
# Table name: rosters
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  league_id  :integer
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Roster, :type => :model do
	# ---- associations ---- #
	it { is_expected.to belong_to(:user) }
	it { is_expected.to belong_to(:league) }
	it { is_expected.to have_and_belong_to_many(:contestants) }

	# ---- dummy data ---- #
	before do
		@roster1 = Roster.create(:user_id => 2, :league_id => 4)
		@roster_no_user = Roster.create(:user_id => nil, :league_id => 10)
		@roster_no_league = Roster.create(:user_id => 2, :league_id => nil)
	end

	# ---- test ---- #
	describe 'fields present' do
		it { expect(@roster1.user_id).to eq 2 }
		it { expect(@roster1.league_id).to eq 4 }
		context 'when user id is nil' do
			it { expect(@roster_no_user).to be_invalid }
		end
		context 'when league id is nil' do
			it { expect(@roster_no_league).to be_invalid }
		end
	end
end

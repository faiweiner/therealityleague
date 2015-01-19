# == Schema Information
#
# Table name: episodes
#
#  id                 :integer          not null, primary key
#  season_id          :integer
#  air_date           :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  expected_survivors :integer
#  aired              :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Episode, :type => :model do
	# ---- associations ---- #
	it { is_expected.to belong_to(:show) }
	it { is_expected.to have_many(:rounds) }

	# ---- dummy data ---- #
	before do 
		@show1 = Show.create(:id => 1, :name => 'The Bachelor', :premiere_date => '06/01/2014', :country_origin => 'USA', :description => 'The Bachelor is an American reality television dating game show debuting in 2002 on ABC. For all seasons, the show is hosted by Chris Harrison.')
		@episode1 = Episode.create(:show_id => 1, :air_date => '13/05/2014')
		@episode2 = Episode.create(:show_id => nil, :air_date => '20/05/2014')
		@episode3 = Episode.create(:show_id => 1, :air_date => nil)
	end

	# ---- test ---- #

	describe 'show id' do
		it 'should have a show id' do
			expect(@episode1.show_id).to eq 1
		end

		context 'when show id is empty' do
			it { expect(@episode2).to be_invalid }
		end
	end

	describe	'air_date' do
		it 'should have air_date' do
			expect(@episode1.air_date).to eq '13/05/2014'
		end

		context 'when air date is not specified' do
			it { expect(@episode3).to be_invalid }
		end
	end
end

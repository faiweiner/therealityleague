# == Schema Information
#
# Table name: shows
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  premiere_date    :datetime
#  draft_close_date :datetime
#  country_origin   :string(255)
#  type             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  description      :string(255)
#

require 'rails_helper'

RSpec.describe Show, :type => :model do
	# ---- associations ---- #
	it { is_expected.to have_many(:contestants) }
	it { is_expected.to have_many(:leagues) }
	it { is_expected.to have_many(:episodes) }

	# ---- dummy data ---- #
	before do
		@show1 = Show.create(:name => 'The Bachelor', :premiere_date => '06/01/14', :draft_close_date => '11/01/14', :country_origin => 'USA', :description => 'The Bachelor is an American reality television dating game show debuting in 2002 on ABC. For all seasons, the show is hosted by Chris Harrison.')
		@show2 = Show.create(:name => 'The Bachelorette', :premiere_date => '19/05/14', :draft_close_date => '24/05/14',:country_origin => 'USA', :description => 'The Bachelorette is a spin-off from the American competitive reality dating game show The Bachelor. In its January 2003 debut on ABC, the first season featured Trista Rehn')
		@show3 = Show.create(:name => '', :premiere_date => '', :draft_close_date => '', :country_origin => '')
		@show4 = Show.create(:name => 'The Challenge', :premiere_date => '19/05/14', :draft_close_date => '26/05/14')
		# FIXME - how to handle type in Show
	end

	# ---- general testing ---- #
	context 'name field' do 
		it 'should have a name' do
			expect(@show1.name).to eq 'The Bachelor'
		end
		context	'when name is blank' do
			it { expect(@show3).to be_invalid }
		end
	end

	context 'premiere_date' do
		it 'should have a premiere date' do
			expect(@show1.premiere_date).to eq '06/01/14'
		end

		context 'when premiere date is not specified' do
			it { expect(@show3).to be_invalid }
		end
	end

	context	'draft_close_date' do
		it 'should have a draft close date' do
			expect(@show2.draft_close_date).to eq '24/05/14'
		end

		context	'when draft close date is not specified' do
			it { expect(@show3).to be_invalid }
		end

		it 'should be no more than five days after the first episode has aired' do
			expect(@show4).to be_invalid
		end
	end

end

# 05/19/14
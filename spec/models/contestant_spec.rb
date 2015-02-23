# == Schema Information
#
# Table name: contestants
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  season_id   :integer
#  image       :string(255)
#  age         :integer
#  gender      :string(255)
#  occupation  :string(255)
#  description :text
#  source      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Contestant, :type => :model do
	# ---- associations ---- #
	it { is_expected.to belong_to(:season) }
	it { is_expected.to have_and_belong_to_many(:rosters) }
	it { is_expected.to have_many(:points) }
	it { is_expected.to have_many(:episodes) }

	# ---- dummy data ---- #
	before do
		@contestant1 = Contestant.create(:name => 'Tony', :show_id => 1, :age => 25, :gender => :male, :occupation => 'Fire fighter', :status_on_show => 'in', :present => :true)
		@contestantNoShow = Contestant.create(:name => 'Allen', :show_id => nil, :age => 32, :gender => :male, :occupation => 'Finance', :status_on_show => 'in', :present => :true)
		@contestantNoName = Contestant.create(:name => nil)
		@contestantNew = Contestant.new
	end
	# ---- general testing ---- #
	# name
	describe 'name field' do
		it 'should have a name' do
			expect(@contestant1.name).to eq 'Tony'
		end

		context 'when name is empty' do
			it { expect(@contestantNoName).to be_invalid }
		end
	end

	# show ID
	it 'should have show ID' do
		expect(@contestant1.show_id).to eq 1
	end

	it 'must be specified' do
		expect(@contestantNoShow).to be_invalid
	end

	# present
	describe 'present boolean' do
		it 'should default as true' do
			expect(@contestantNew.present).to eq true
		end
	end
end

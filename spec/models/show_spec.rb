# == Schema Information
#
# Table name: shows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  image      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Show, :type => :model do
	# ---- associations ---- #
	it { is_expected.to have_many(:seasons) }
	it { is_expected.to have_many(:events) }
	it { is_expected.to have_many(:episodes) }
	it { is_expected.to have_many(:points) }

	# ---- dummy data ---- #
	before do
		@show1 = Show.create(:name => 'The Bachelor', :image => '/assets/the_bachelor/logo.jpg')
		@show2 = Show.create(:name => 'The Bachelorette', :image => '/assets/the_bachelorette/logo.png')
		@show3 = Show.create(:name => '', :image => '/assets/the_voice/thevoice.jpg')
		@show4 = Show.create(:name => 'Bachelor in Paradise', :image => '/assets/bachelor_paradise/bachelor_paradise.jpg')
		@show5 = Show.create(:name => 'Master Chef', :image => '/assets/master_chef/masterchef.jpg')
		@show6 = Show.create(:name => 'The Challenge', :image => '/assets/the_challenge/thechallenge.jpg')
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
end

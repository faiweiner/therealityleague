# == Schema Information
#
# Table name: leagues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  commissioner_id :integer
#  show_id         :integer
#  public_access   :boolean          default(TRUE)
#  draft_type      :string(255)
#  scoring_system  :integer
#  created_at      :datetime
#  updated_at      :datetime
#  league_key      :string(255)
#  league_password :string(255)
#

require 'rails_helper'

RSpec.describe League, :type => :model do
	it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to belong_to(:show) }
  it { is_expected.to have_many(:rosters) } # Through users
  it { is_expected.to have_many(:rounds) }

  # FIXME
  pending 'associations with future models' do
    it { is_expected.to have_one(:scores) }
	end

	before do
		# private league
		@league1 = League.create(:name => 'The Best Private League', :commissioner_id => 2, :show_id => 2, :public_access => false, :draft_type => :fantasy, :scoring_system => 2)
		# public league
		@league2 = League.create(:name => 'The Public League', :commissioner_id => 1, :show_id => 2, :public_access => true, :draft_type => :bracket, :scoring_system => 2)
	end
  
  it 'should have a name' do
  	expect(@league1	.name).to eq 'The Best Private League'
  end

  it 'should have a commissioner assigned' do
		expect(@league1.commissioner_id).to eq 2
  end

  it 'should have empty league key and password if it\'s a public league' do
  	expect(@league2.public_access).to be(true)
  end

  it 'should assign league key and password if it\'s a private league' do
  	expect(@league1.public_access).to be(false)
  	expect(@league1.league_key).to be
  	expect(@league1.league_password).to be
  end
end

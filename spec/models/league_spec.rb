# == Schema Information
#
# Table name: leagues
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  commissioner_id :integer
#  season_id       :integer
#  public_access   :boolean          default(TRUE)
#  type            :string(255)
#  draft_deadline  :datetime
#  draft_limit     :integer
#  contestant_cap  :integer
#  scoring_system  :integer
#  league_key      :string(255)
#  league_password :string(255)
#  active          :boolean          default(TRUE)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

RSpec.describe League, :type => :model do
  # ---- associations ---- #
	it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to belong_to(:show) }
  it { is_expected.to have_many(:rosters) } # Through users
  it { is_expected.to have_many(:rounds) }

  # FIXME
  pending 'associations with future models' do
    it { is_expected.to have_many(:scores) }
	end
  # ---- dummy data ---- #
	before do
		# private league
		@league1 = League.create(:name => 'The Best Private League', :commissioner_id => 2, :show_id => 2, :public_access => false, :draft_type => :fantasy, :scoring_system => 2)
		# public leagues
		@league2 = League.create(:name => 'The Public League', :commissioner_id => 1, :show_id => 2, :public_access => true, :draft_type => :bracket, :scoring_system => 2)
    @league3 = League.create(:name => '', :commissioner_id => '', :show_id => '', :public_access => true, :draft_type => '', :scoring_system => 2 )
	end
  
  # ---- general testing ---- #
  describe 'name field' do
    it 'should have a name' do
    	expect(@league1.name).to eq 'The Best Private League'
      expect(@league2.name).to eq 'The Public League'
    end
    context 'when name is empty' do
      it { expect(@league3).to be_invalid }
    end
  end

  describe 'commissioner field' do
    it 'should have a commissioner' do
  		expect(@league1.commissioner_id).to eq 2
    end
    context 'when a commissioner is not assigned' do
      it { expect(@league3).to be_invalid }
    end
  end

  describe 'show ID field' do
    it 'should have a show' do
      expect(@league1.show_id).to eq 2
    end
    context 'when a show is not assigned' do
      it { expect(@league3).to be_invalid }
    end
  end

  describe 'public and private league access' do
    it 'should have empty league key and password if it\'s a public league' do
    	expect(@league2.public_access).to be(true)
    end

    it 'should assign league key and password if it\'s a private league' do
    	expect(@league1.public_access).to be(false)
    	expect(@league1.league_key).to be
    	expect(@league1.league_password).to be
    end
  end

  describe 'draft type field' do
    it 'should have a draft type' do
      expect(@league1.draft_type).to eq :fantasy 
      expect(@league2.draft_type).to eq :bracket
    end
    context 'when a draft type is not assigned' do
      it { expect(@league3).to be_invalid }
    end
  end

  describe '#gen_league_key' do
    #FIXME!
  end

  describe '#gen_league_password' do
    #FIXME!
  end

  describe '#set_up_league' do
    #FIXME!
  end
end

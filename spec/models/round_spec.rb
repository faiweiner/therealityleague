# == Schema Information
#
# Table name: rounds
#
#  id         :integer          not null, primary key
#  league_id  :integer
#  episode_id :integer
#

require 'rails_helper'

RSpec.describe Round, :type => :model do

	# ---- associations ---- #
	it { is_expected.to belong_to(:league) }
	it { is_expected.to belong_to(:episode) }

	# ---- dummy data ---- #
	before do 
		@show1 = Show.create(:id => 1, :name => 'The Bachelor', :premiere_date => '06/01/14', :draft_close_date => '11/01/14', :country_origin => 'USA', :description => 'The Bachelor is an American reality television dating game show debuting in 2002 on ABC. For all seasons, the show is hosted by Chris Harrison.')
	end

	# ---- general tests ---- #
	describe 'league id' do
	end

	describe 'episode id' do
	end
end

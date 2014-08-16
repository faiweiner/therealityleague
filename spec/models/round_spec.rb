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
	it { is_expected.to belong_to(:league) }
	it { is_expected.to belong_to(:episode) }
end

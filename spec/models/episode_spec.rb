# == Schema Information
#
# Table name: episodes
#
#  id      :integer          not null, primary key
#  show_id :integer
#

require 'rails_helper'

RSpec.describe Episode, :type => :model do
	it { is_expected.to belong_to(:show) }
	it { is_expected.to have_many(:rounds) }
end

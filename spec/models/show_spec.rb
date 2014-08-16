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
	it { is_expected.to have_many(:contestants) }
	it { is_expected.to have_many(:leagues) }
	it { is_expected.to have_many(:episodes) }
	it { is_expected.to have_many(:scorings) }

end

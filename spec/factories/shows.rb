# == Schema Information
#
# Table name: shows
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  premiere_date  :datetime
#  finale_date    :datetime
#  country_origin :string(255)
#  type           :string(255)
#  description    :text
#  episode_count  :integer
#  image          :string(255)
#  series_id      :integer
#  published      :boolean          default(FALSE)
#  expired        :boolean
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show do
  end
end

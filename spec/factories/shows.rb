# == Schema Information
#
# Table name: shows
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  premiere_date  :datetime
#  country_origin :string(255)
#  type           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  description    :text
#  image          :string(255)
#  series_id      :integer
#  expired        :boolean          default(FALSE)
#  episode_count  :integer
#  finale_date    :datetime
#  shows          :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show do
  end
end

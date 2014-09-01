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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show do
  end
end

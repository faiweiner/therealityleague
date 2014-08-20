# == Schema Information
#
# Table name: scores
#
#  id            :integer          not null, primary key
#  round_id      :integer
#  contestant_id :integer
#  event         :string(255)
#  points        :integer
#  created_at    :datetime
#  updated_at    :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :score do
    round_id 1
    contestant_id 1
    event "MyString"
    points 1
  end
end

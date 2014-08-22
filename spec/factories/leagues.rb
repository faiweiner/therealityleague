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
#  draft_limit     :integer          default(5)
#  expired         :boolean          default(FALSE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :league do
    name 'MyString'
    commissioner_id { generate(:commissioner_id)}
    show_id { generate(:show_id)}
    public_access	:FALSE
    draft_type ''
  end
end

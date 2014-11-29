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

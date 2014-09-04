# == Schema Information
#
# Table name: contestants
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  season_id      :integer
#  image          :string(255)
#  age            :integer
#  gender         :string(255)
#  occupation     :string(255)
#  description    :text
#  status_on_show :string(255)
#  present        :boolean          default(TRUE)
#  episode_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#

FactoryGirl.define do
	factory :contestant do
		name 'MyString'
		season_id { generate(:season_id) }
		image 'MyString'
		
	end
end
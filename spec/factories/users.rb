# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  email            :string(255)
#  username         :string(255)
#  password_digest  :string(255)
#  avatar           :string(255)
#  oauth_token      :string(255)
#  oauth_expires_at :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  admin            :boolean          default(FALSE)
#

FactoryGirl.define do
	factory :user do
		email 								{ generate(:email) }
		username 							{ generate(:username) }
		avatar 								'placeholder'
		password 							'chicken'
		password_confirmation 'chicken'
		admin 								false
	end

end

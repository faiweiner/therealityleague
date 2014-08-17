FactoryGirl.define do
	factory :user do
		email 'user@email.com'
		username 'username'
		password 'chicken'
		password_confirmation 'chicken'
	end
end
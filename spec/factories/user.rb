puts 'is this thig on?'
FactoryGirl.define do
	factory :user do
		username 'username'
		email 'user@email.com'
		password 'chicken'
		password_confirmation 'chicken'
	end
end
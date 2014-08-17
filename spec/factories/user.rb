FactoryGirl.define do
	factory :user do
		email 'factorygirl@email.com'
		username 'factorygirl'
		password 'chicken'
		password_confirmation 'chicken'
	end
end
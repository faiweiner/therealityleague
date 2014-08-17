FactoryGirl.define do
	factory :user do
		email { generate(:email) }
		username { generate(:username) }
		password 'chicken'
		password_confirmation 'chicken'
	end

	trait :bad do
		email '@'
	end
end
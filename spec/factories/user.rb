FactoryGirl.define do
	factory :user do
		email 'user1@email.com'
		username 'username1'
		password 'chicken'
		password_confirmation 'chicken'
	end

	# user with empty email
	factory :user_empty_email, class: User do
		email nil
		username 'usernameEE'
		password 'chicken'
		password_confirmation 'chicken'
	end

	factory :user_dup_email, class: User do
		email 'user1@email.com'
		username 'usernameDE'
		password 'chicken'
		password_confirmation 'chicken'
	end
end
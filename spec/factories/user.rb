FactoryGirl.define do
	factory :user do
		email 'user@email.com'
		username 'username'
		password 'chicken'
		password_confirmation 'chicken'

		factory :user_nil_email do
			email nil
		end

		factory :user_empty_email do
			email ''
		end

		factory :user_dup_email do
			username 'usernameDE'
			# duplicate email inherit from standard user 
		end

		factory :user_bad_email do
			email 'user@bad_email.'
		end

		factory :user_dup_username, class: User do
			email 'userDU@email.com'
			# duplicate username inherit from user
		end

		factory :user_short, class: User do
			username 'short'
		end

		factory :user_miss_pw do
			password 'chicken'
			password_confirmation 'turkey'
		end

		factory :user_nil_pw do
			password nil
			password_confirmation nil
		end

		factory :user_blank_pw do
			password ''
			password_confirmation ''
		end
	end

end
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
#

require 'rails_helper'

RSpec.describe User, :type => :model do

	# ---- associations ---- #
	it { is_expected.to have_and_belong_to_many(:leagues) }
	it { is_expected.to have_many(:rosters) }
	it { is_expected.to have_many(:contestants) } # Through rosters
	it { is_expected.to have_many(:shows) } # Through leagues
	it { is_expected.to have_many(:rounds) } # Through leagues

	# ---- dummy data ---- #
	before do
		@user1 = FactoryGirl.create(:user)
		@user2 = User.create(:email => 'user2@email.com', :username => 'username2', :password => 'chicken', :password_confirmation => 'chicken')
		# user with invalid email address
		@user3 = User.create(:email => '', :username => 'username3', :password => 'chicken', :password_confirmation => 'chicken')
		@user5 = User.create(:email => 'user2@email.com', :username => 'username5', :password => 'chicken', :password_confirmation => 'chicken')

		# user with invalid username
		@user4 = User.create(:email => 'user4@email.com', :username => 'username3', :password => 'chicken', :password_confirmation => 'chicken')
		@user6 = User.create(:email => 'user6@email.com', :username => 'user6', :password => 'chicken', :password_confirmation => 'chicken')
		
		# users with bad passwords
		@user7 = User.create(:email => 'user7@email.com', :username => 'username7', :password => 'chicken', :password_confirmation => 'turkey')
		@user8 = User.create(:email => 'user8@email.com', :username => 'username8', :password => '', :password_confirmation => '')
	end
	
	# ---- general model checks ---- #
	# email
	describe 'email field' do
		# existence and uniqueness
		it 'shold have an email' do
			expect(@user1.email).to eq 'user1@email.com'
		end

		context 'when email is blank' do
			it { expect(@user3).to be_invalid }
		end

		it 'shold have a unique email' do
			expect(@user4).to validate_uniqueness_of(:email)
		end

		context 'when an email address is not unique' do
			it { expect(@user5).to be_invalid }
		end

		context 'when an email is a duplicate' do
			it { expect(@user5).to be_invalid }
		end

		# format
		# context 'when email fromat is valid' do
		# 	it 'should be valid' do
		# 		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	 #      addresses.each do |valid_address|
	 #        @user2.email = valid_address
	 #        expect(@user2).to be_valid
	 #      end
	 #   		expect(@user2).to be_valid
		# 	end
		# end
		
		it 'should be an invalid email' do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user4.email = invalid_address
				expect(@user4).to be_invalid
			end
		end
	end

	# username
	describe 'username field' do

		it 'should have a username' do
			expect(@user1.username).to eq 'username1'
			expect(@user2.username).to eq 'username2'
		end
		it 'shold have a unique username' do
			expect(@user4).to validate_uniqueness_of(:username)
		end

		context 'when username is too short' do
			it { expect(@user6).to be_invalid }
		end

		context 'when username is a duplicate' do
			it { expect(@user4).to be_invalid }
		end

		context 'when username is blank' do
			it { expect(@user3).to be_invalid }
		end
	end

	# password
	describe 'password field' do
		it 'should have a password' do
			expect(@user1.password).to eq 'chicken'
			expect(@user1.password_confirmation).to eq 'chicken'
		end

		it 'should be between 6 and 20 characters' do
			passwords = ['aaa', 'aaaaaaaaaaaaaaaaaaaaaaaa']
			passwords.each do |invalid_password|
				@user7.password = invalid_password
				@user7.password_confirmation = invalid_password
				expect(@user7).to be_invalid
			end
		end
		context 'when password is not present' do
			it { expect(@user8).to be_invalid }
		end

		context 'when passwords don\'t match' do
			it { expect(@user7).to be_invalid }
		end

	end
end

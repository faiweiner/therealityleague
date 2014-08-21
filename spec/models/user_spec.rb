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

require 'rails_helper'

RSpec.describe User, :type => :model do

	# ---- associations ---- #
	it { is_expected.to have_and_belong_to_many(:leagues) }
	it { is_expected.to have_many(:rosters) }
	it { is_expected.to have_many(:contestants) } # Through rosters
	it { is_expected.to have_many(:shows) } # Through leagues
	it { is_expected.to have_many(:rounds) } # Through leagues

	# ---- general model checks ---- #
	# email
	describe 'email field' do
		# existence and uniqueness
		it 'shold have an email' do
			user = FactoryGirl.create(:user)
			user_email = user.email
			expect(user.email).to eq user_email
		end

		context 'when email is blank' do
			it { expect(FactoryGirl.build(:user, email: '')).to be_invalid }
		end

		it 'shold have a unique email' do
			new_user = FactoryGirl.build(:user, username: 'newuser')
			expect(new_user).to validate_uniqueness_of(:email)
		end

		context 'when an email address is not unique' do
			it 'should fail' do
				user = FactoryGirl.create(:user)
				expect(FactoryGirl.build(:user, email: 'username1@email.com')).to be_invalid
			end
		end

		# format
		context 'when email fromat is valid' do
			it 'should be valid' do
				@user = FactoryGirl.create(:user)
				addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
				addresses.each do |valid_address|
					@user.email = valid_address
					expect(@user).to be_valid
				end
				expect(@user).to be_valid
			end
		end
		
		context 'when an invalid email address' do
			it 'should be invalid' do
				@user = FactoryGirl.create(:user)
				addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
				addresses.each do |invalid_address|
					@user.email = invalid_address
					expect(@user).to be_invalid
				end
			end
		end

	end

	# username
	describe 'username field' do

		it 'should have a username' do
			expect(FactoryGirl.create(:user).username).to eq FactoryGirl.attributes_for(:user)[:username]
		end

		it 'shold have a unique username' do
			expect(FactoryGirl.create(:user)).to validate_uniqueness_of(:username)
		end

		context 'when username is not unique' do
			it 'should be invalid' do
				user = FactoryGirl.create(:user)
				new_user = FactoryGirl.build(:user, email: 'new_user@email.com')
				expect(new_user).to be_invalid
			end
		end

		context 'when username is too short' do
			it 'should be invalid' do
				expect(FactoryGirl.build(:user, username: 'short')).to be_invalid
			end
		end

		context 'when username is blank' do
			it 'should be invalid' do
				expect(FactoryGirl.build(:user, username: '')).to be_invalid
			end
		end
	end

	# password
	describe 'password field' do
		it 'should have a password' do
			@user = FactoryGirl.create(:user)
			expect(@user.password).to eq 'chicken'
			expect(@user.password_confirmation).to eq 'chicken'
		end

		context 'when password is between 6 and 20 characters' do
			it 'should be valid' do
				@user = FactoryGirl.create(:user)
				expect(@user).to be_valid
			end
		end

		context 'when password is less than 6 or more than 20 characters' do
			it 'should be invalid' do
				@user = FactoryGirl.create(:user)
				passwords = ['aaa', 'aaaaaaaaaaaaaaaaaaaaaaaa']
				passwords.each do |invalid_password|
					@user.password = invalid_password
					@user.password_confirmation = invalid_password
					expect(@user).to be_invalid
				end
				expect(@user).to be_invalid
			end
		end

		context 'when password is not present' do
			it 'should be invalid' do
				expect(FactoryGirl.build(:user, password: '', password_confirmation: '')).to be_invalid
			end
		end

		context 'when passwords don\'t match' do
			it { expect(FactoryGirl.build(:user, password: 'turkey', password_confirmation: 'chicken')).to be_invalid }
		end
	end
end

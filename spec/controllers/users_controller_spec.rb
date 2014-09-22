require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

	describe 'GET #index' do 
		it 'renders the :index view' do
			get :index
			expect(response).to render_template('index')
		end

		pending 'responds successfully with an HTTP 200 status code'
		pending 'generates a list of all users' 
		pending 'is restricted to only admin'

	end 

	describe 'POST #create' do 
		context 'with valid attributes' do 
			it 'saves the new user to the database' do
				user = FactoryGirl.create(:user)
				post :create, :user => { 'email' => user.email, 'username' => user.username, 'password' => user.password, 'password_digest' => user.password_digest }
				expect(user).to be_valid
				expect(response).to be_successful
			end

			it 'add 1 user to total users count' do
				expect {
					post :create, user: FactoryGirl.attributes_for(:user)
				}.to change(User, :count).by(1)
			end

			it 'redirects to the home page' do
				expect(response).to redirect_to(root_path)
				expect(response).status.to eq == '303'
			end
		end 

		context 'with invalid attributes' do 
			it 'does not save the new user to the database' do
				user = FactoryGirl.build(:user, :bad)
				post :create, :user => { 'email' => user.email, 'username' => user.username, 'password' => user.password, 'password_digest' => user.password_digest }
				expect(user).to be_invalid
				expect(response).to be_successful # FIXME!
			end

			it 're-renders the :new template' do
			end
		end 
	end

	describe 'GET #new' do 
		it 'takes five parameters and returns a User object' do
			@user.is_expected_to be_an_instance_of User
		end
		
		it 'assigns a new user to @user' do
			expect(@user).to eq FactoryGirl.build(:user)
		end
		it 'renders the :new template for user' 
	end 

	describe 'GET #show' do 
		it 'assigns the requested contact to @contact' 
		it 'renders the :show template' 
	end 
end

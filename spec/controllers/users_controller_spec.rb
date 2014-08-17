require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
	describe 'GET /users' do
		before do
			3.times do |i|
				User.create(:email => 'user#{i}@email.com', :username => 'username#{i}', :password => 'chicken', :password_confirmation => 'chicken')
			end
		end

		describe "GET #index" do 
			it "populates a list of all users" 
			it "renders the :index view" 
		end 
		describe "POST #create" do 
			context "with valid attributes" do 
				it "saves the new user to the database" 
				it "redirects to the home page" 
			end 
			context "with invalid attributes" do 
				it "does not save the new user to the database" do
				end
				it "re-renders the :new template" do
				end
			end 
		end
		describe "GET #new" do 
			it "assigns a new user to @user" 
			it "renders the :new template for user" 
		end 
		describe "GET #show" do 
			it "assigns the requested contact to @contact" 
			it "renders the :show template" 
		end 
	end
end

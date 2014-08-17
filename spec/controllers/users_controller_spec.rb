require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
	describe "GET #index" do 
		# it "responds successfully with an HTTP 200 status code" do
		# 	get :index
		# 	expect(response).to be_success
		# 	expect(response).to have_http_status(200)
		# end
		it "renders the :index view" do
			get :index
      expect(response).to render_template("index")
		end
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

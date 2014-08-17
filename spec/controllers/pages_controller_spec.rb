require 'rails_helper'

RSpec.describe PagesController, :type => :controller do
  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user, no_capybara: true }

    describe "using a 'new' action" do
      before { get new_user_path }      
      specify { response.should redirect_to(root_path) }
    end

    describe "using a 'create' action" do
      before do
        @user_new = {name: "Example User", 
                     email: "user@example.com", 
                     password: "foobar", 
                     password_confirmation: "foobar"} 
        post users_path, user: @user_new 
      end

      specify { response.should redirect_to(root_path) }
    end
  end   
end
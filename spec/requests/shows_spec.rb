require 'rails_helper'

RSpec.describe "Shows", :type => :request do
  describe "GET /shows" do
    it "works! (now write some real specs)" do
      get shows_path
      expect(response.status).to be(200)
    end
  end
end

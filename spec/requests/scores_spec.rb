require 'rails_helper'

RSpec.describe "Scores", :type => :request do
  describe "GET /scores" do
    it "works! (now write some real specs)" do
      get scores_path
      expect(response.status).to be(200)
    end
  end
end

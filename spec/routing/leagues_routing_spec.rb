require "rails_helper"

RSpec.describe LeaguesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/leagues").to route_to("leagues#index")
    end

    it "routes to #new" do
      expect(:get => "/leagues/new").to route_to("leagues#new")
    end

    it "routes to #show" do
      expect(:get => "/leagues/1").to route_to("leagues#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/leagues/1/edit").to route_to("leagues#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/leagues").to route_to("leagues#create")
    end

    it "routes to #update" do
      expect(:put => "/leagues/1").to route_to("leagues#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/leagues/1").to route_to("leagues#destroy", :id => "1")
    end

  end
end

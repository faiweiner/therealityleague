require "rails_helper"

RSpec.describe ShowsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/shows").to route_to("shows#index")
    end

    it "routes to #new" do
      expect(:get => "/shows/new").to route_to("shows#new")
    end

    it "routes to #show" do
      expect(:get => "/shows/1").to route_to("shows#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/shows/1/edit").to route_to("shows#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/shows").to route_to("shows#create")
    end

    it "routes to #update" do
      expect(:put => "/shows/1").to route_to("shows#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/shows/1").to route_to("shows#destroy", :id => "1")
    end

  end
end

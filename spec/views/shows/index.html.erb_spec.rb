require 'rails_helper'

RSpec.describe "shows/index", :type => :view do
  before(:each) do
    assign(:shows, [
      Show.create!(),
      Show.create!()
    ])
  end

  it "renders a list of shows" do
    render
  end
end

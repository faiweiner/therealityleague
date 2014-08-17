require 'rails_helper'

RSpec.describe "leagues/index", :type => :view do
  before(:each) do
    assign(:leagues, [
      League.create!(
        :name => "Name"
      ),
      League.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of leagues" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end

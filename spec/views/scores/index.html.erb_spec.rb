require 'rails_helper'

RSpec.describe "scores/index", :type => :view do
  before(:each) do
    assign(:scores, [
      Score.create!(
        :round_id => 1,
        :contestant_id => 2,
        :event => "Event",
        :points => 3
      ),
      Score.create!(
        :round_id => 1,
        :contestant_id => 2,
        :event => "Event",
        :points => 3
      )
    ])
  end

  it "renders a list of scores" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Event".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end

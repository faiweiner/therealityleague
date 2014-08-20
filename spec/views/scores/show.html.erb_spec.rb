require 'rails_helper'

RSpec.describe "scores/show", :type => :view do
  before(:each) do
    @score = assign(:score, Score.create!(
      :round_id => 1,
      :contestant_id => 2,
      :event => "Event",
      :points => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Event/)
    expect(rendered).to match(/3/)
  end
end

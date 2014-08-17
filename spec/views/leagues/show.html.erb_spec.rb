require 'rails_helper'

RSpec.describe "leagues/show", :type => :view do
  before(:each) do
    @league = assign(:league, League.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end

require 'rails_helper'

RSpec.describe "shows/new", :type => :view do
  before(:each) do
    assign(:show, Show.new())
  end

  it "renders new show form" do
    render

    assert_select "form[action=?][method=?]", shows_path, "post" do
    end
  end
end

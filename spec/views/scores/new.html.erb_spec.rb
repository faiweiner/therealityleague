require 'rails_helper'

RSpec.describe "scores/new", :type => :view do
  before(:each) do
    assign(:score, Score.new(
      :round_id => 1,
      :contestant_id => 1,
      :event => "MyString",
      :points => 1
    ))
  end

  it "renders new score form" do
    render

    assert_select "form[action=?][method=?]", scores_path, "post" do

      assert_select "input#score_round_id[name=?]", "score[round_id]"

      assert_select "input#score_contestant_id[name=?]", "score[contestant_id]"

      assert_select "input#score_event[name=?]", "score[event]"

      assert_select "input#score_points[name=?]", "score[points]"
    end
  end
end

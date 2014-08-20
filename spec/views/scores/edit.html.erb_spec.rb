require 'rails_helper'

RSpec.describe "scores/edit", :type => :view do
  before(:each) do
    @score = assign(:score, Score.create!(
      :round_id => 1,
      :contestant_id => 1,
      :event => "MyString",
      :points => 1
    ))
  end

  it "renders the edit score form" do
    render

    assert_select "form[action=?][method=?]", score_path(@score), "post" do

      assert_select "input#score_round_id[name=?]", "score[round_id]"

      assert_select "input#score_contestant_id[name=?]", "score[contestant_id]"

      assert_select "input#score_event[name=?]", "score[event]"

      assert_select "input#score_points[name=?]", "score[points]"
    end
  end
end

require 'rails_helper'

RSpec.describe "questions/show.html.erb", :type => :view do
  before(:each) do
    @question = mock_model(Question)
    allow(@question.limit_datetime).to receive(:strftime)
    allow(@question.created_at).to receive(:in_time_zone)
    allow(@question.created_at).to receive(:strftime)
    @answers = mock_model(Answer)
    expect(@answers).to receive(:each).and_return(@answers)
    assign(:question, @question)
    assign(:answers, @answers)
  end

  context '詳細画面として表示するとき' do
    it '正しく描画できること' do
      render
    end
  end
end

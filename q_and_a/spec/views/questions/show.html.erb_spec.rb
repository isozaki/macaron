require 'rails_helper'

RSpec.describe "questions/show.html.erb", :type => :view do
  before(:each) do
    @question = FactoryGirl.create(:question)
    @answers = mock_model(Answer)
    @question_attachment = mock_model(QuestionAttachment)
    @answer_attachment = mock_model(AnswerAttachment)
    assign(:question, @question)
    assign(:answers, @answers)
  end

  context '詳細画面として表示するとき' do
    it '正しく描画できること' do
      render
    end
  end
end

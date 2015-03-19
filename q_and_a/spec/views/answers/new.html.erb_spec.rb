require 'rails_helper'

RSpec.describe "answers/new.html.erb" do
  context 'エラーがないとき' do
    before(:each) do
      @question = mock_model(Question, id: 1)
      @answer = Answer.new
      assign(:question, @question)
      assign(:answer, @answer)
    end

    it '正しく表示されること' do
      render
    end
  end
end

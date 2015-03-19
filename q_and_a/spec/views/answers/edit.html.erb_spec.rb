require 'rails_helper'

RSpec.describe "answers/edit.html.erb", :type => :view do
  context 'エラーがないとき' do
    before(:each) do
      @question = mock_model(Question, id: 1)
      @answer = mock_model(Answer)
      assign(:question, @question)
      assign(:answer, @answer)
    end

    it '正しく表示されること' do
      render
    end
  end
end

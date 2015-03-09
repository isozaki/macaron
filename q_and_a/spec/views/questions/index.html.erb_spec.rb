require 'rails_helper'

describe "questions/index.html.erb" do
  context 'エラーがないとき' do
    before(:each) do
      @questions = mock_model(Question)
      expect(@questions).to receive(:each).and_return @questions
      assign(:question, @quetion)
    end

    it '正しく表示されること' do
      render
    end
  end
end

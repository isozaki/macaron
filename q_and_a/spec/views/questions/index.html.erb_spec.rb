require 'rails_helper'

describe "questions/index.html.erb" do
  context 'エラーがないとき' do
    before(:each) do
      skip
    end

    before(:each) do
      @question = mock_model(Question)
      @questions = [@question]
      kaminari_stubs_to(@questions)

      expect(@questions).to receive(:each).and_return @questions
      assign(:questions, @questions)
    end

    it '正しく表示されること' do
      render
    end
  end
end

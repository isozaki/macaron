require 'rails_helper'

describe "questions/index.html.erb" do
  context 'エラーがないとき' do
    before(:each) do
      @question = mock_model(Question)
      assign(:question, @quetion)
    end

    it '正しく表示されること' do
      render
    end
  end
end

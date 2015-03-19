require 'rails_helper'

RSpec.describe "questions/edit.html.erb", :type => :view do
  context 'エラーがないとき' do
    before(:each) do
      @question = mock_model(Question)
      assign(:question, @question)
    end

    it '正しく表示されること' do
      render
    end
  end
end

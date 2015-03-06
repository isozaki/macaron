require 'rails_helper'

describe "questions/new.html.erb" do
  context 'エラーがないとき' do
    before(:each) do
      @question = Question.new
      assign(:question, @quetion)
    end

    it '正しく表示されること' do
      render
    end
  end
end

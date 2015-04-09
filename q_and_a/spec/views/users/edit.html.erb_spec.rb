require 'rails_helper'

RSpec.describe "users/edit.html.erb", :type => :view do
  context 'エラーがないとき' do
    before(:each) do
      @user = mock_model(User)
      assign(:user, @user)
    end

    it '正しく表示されること' do
      render
    end
  end
end

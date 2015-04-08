require 'rails_helper'

RSpec.describe "users/index.html.erb", :type => :view do
  context 'エラーがないとき' do
    before(:each) do
      @user = mock_model(User)
      @users = [@user]

      assign(:users, @users)
    end

    it '正しく表示されること' do
      render
    end
  end
end

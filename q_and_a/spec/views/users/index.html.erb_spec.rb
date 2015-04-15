require 'rails_helper'

RSpec.describe "users/index.html.erb", :type => :view do
  before(:each) do
    skip
  end

  context 'エラーがないとき' do
    before(:each) do
      @user = mock_model(User)
      @users = [@user]
      kaminari_stubs_to(@users)

      assign(:users, @users)
    end

    it '正しく表示されること' do
      render
    end
  end
end

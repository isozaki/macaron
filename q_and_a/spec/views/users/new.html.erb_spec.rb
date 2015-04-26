require 'rails_helper'

RSpec.describe "users/new.html.erb", :type => :view do
  context 'エラーがないとき' do
    before(:each) do
      @user = User.new
      assign(:user, @user)
    end

    it '正しく表示されること' do
      render
    end
  end
end

require 'rails_helper'

RSpec.describe "users/show.html.erb", :type => :view do
  before(:each) do
    @user = FactoryGirl.create(:user)
    assign(:user, @user)
  end

  context '詳細画面として表示するとき' do
    it '正しく描画できること' do
      render
    end
  end
end

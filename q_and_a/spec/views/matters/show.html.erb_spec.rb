require 'rails_helper'

RSpec.describe "matters/show.html.erb", :type => :view do
  before(:each) do
    @matter = FactoryGirl.create(:matter)
    @user = FactoryGirl.create(:user)
    @matter_user = FactoryGirl.create(:matter_user, matter: @matter, user: @user)
    @matter_users = [@matter_user]

    assign(:matter, @matter)
    assign(:matter_users, @matter_users)
  end

  context '詳細画面として表示するとき' do
    it '正しく描画できること' do
      render
    end
  end
end

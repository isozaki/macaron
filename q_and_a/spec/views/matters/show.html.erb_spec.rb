require 'rails_helper'

RSpec.describe "matters/show.html.erb", :type => :view do
  before(:each) do
    @matter = FactoryGirl.create(:matter)
    assign(:matter, @matter)
  end

  context '詳細画面として表示するとき' do
    it '正しく描画できること' do
      render
    end
  end
end

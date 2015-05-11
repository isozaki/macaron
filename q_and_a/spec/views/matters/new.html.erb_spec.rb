require 'rails_helper'

RSpec.describe "matters/new.html.erb", :type => :view do
  context 'エラーがないとき' do
    before(:each) do
      @matter = Matter.new
      assign(:matter, @matter)
    end

    it '正しく表示されること' do
      render
    end
  end
end

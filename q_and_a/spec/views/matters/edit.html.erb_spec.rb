require 'rails_helper'

RSpec.describe "matters/edit.html.erb", :type => :view do
  context 'エラーがないとき' do
    before(:each) do
      @matter = mock_model(Matter)
      assign(:matter, @matter)
    end

    it '正しく表示されること' do
      render
    end
  end
end

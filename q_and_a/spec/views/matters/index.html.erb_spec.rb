require 'rails_helper'

RSpec.describe "matters/index.html.erb", :type => :view do
  context 'エラーがないとき' do
    before(:each) do
      @matter = mock_model(Matter)
      @matters = [@matter]

      expect(@matters).to receive(:each).and_return @matters
      assign(:matters, @matters)
    end

    it '正しく表示されること' do
      render
    end
  end
end

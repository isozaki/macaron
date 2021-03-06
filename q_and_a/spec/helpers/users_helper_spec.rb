require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, :type => :helper do
  describe 'admin_name' do
    context 'adminが0のとき' do
      before(:each) do
        @user = mock_model(User, admin: false)
        @admin = @user.admin
      end

      it { expect(helper.admin_name(@admin)).to eq '無' }
    end

    context 'adminが1のとき' do
      before(:each) do
        @user = mock_model(User, admin: true)
        @admin = @user.admin
      end

      it { expect(helper.admin_name(@admin)).to eq '有' }
    end
  end
end

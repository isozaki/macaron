# == Schema Information
#
# Table name: matter_users
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  matter_id  :integer          not null
#  deleted    :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe MatterUser, :type => :model do
  describe '検証について' do
    def valid_attributes
      {
        user_id: 1,
        matter_id: 1
      }
    end

    before(:each) do
      @matter_user = MatterUser.new(valid_attributes)
    end

    subject { @matter_user }

    describe 'user_id' do
      context 'nilが指定されるとき' do
        before(:each) { subject.user_id = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されるとき' do
        before(:each) { subject.user_id = '' }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'matter_id' do
      context 'nilが指定されるとき' do
        before(:each) { subject.matter_id = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されるとき' do
        before(:each) { subject.matter_id = '' }

        it { is_expected.not_to be_valid }
      end
    end
  end
end

# == Schema Information
#
# Table name: matters
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  deleted    :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Matter, :type => :model do
  describe '検証について' do
    def valid_attributes
      { title: 'タイトル' }
    end

    before(:each) do
      @matter = Matter.new(valid_attributes)
    end

    subject { @matter }

    describe 'title' do
      context 'nilが指定されるとき' do
        before(:each) { subject.title = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されるとき' do
        before(:each) { subject.title = '' }

        it { is_expected.not_to be_valid }
      end

      context '最大長が指定されたとき' do
        before(:each) { subject.title = 'あ' * 255 }

        it { is_expected.to be_valid }
      end

      context '最大長より長い文字が指定されたとき' do
        before(:each) { subject.title = 'あ' * 256 }

        it { is_expected.not_to be_valid }
      end
    end
  end
end

# == Schema Information
#
# Table name: answers
#
#  id                :integer          not null, primary key
#  question_id       :integer          not null
#  answer            :text             not null
#  deleted           :integer          default(0), not null
#  created_user_name :string(64)       not null
#  updated_user_name :string(64)       not null
#  created_at        :datetime
#  updated_at        :datetime
#

require 'rails_helper'

RSpec.describe Answer do
  describe '検証について' do
    def valid_attributes
      {
        question_id: 1,
        answer: '回答',
        created_user_name: '回答者',
        updated_user_name: '回答者'
      }
    end

    before(:each) do
      @answer = Answer.new(valid_attributes)
    end

    subject { @answer }

    describe 'question_id' do
      context 'nilが指定されるとき' do
        before(:each) { subject.question_id = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されるとき' do
        before(:each) { subject.question_id = '' }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'answer' do
      context 'nilが指定されるとき' do
        before(:each) { subject.answer = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されるとき' do
        before(:each) { subject.answer = '' }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'created_user_name' do
      context 'nilが指定されるとき' do
        before(:each) { subject.created_user_name = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されるとき' do
        before(:each) { subject.created_user_name = '' }

        it { is_expected.not_to be_valid }
      end

      context '最大長が指定されたとき' do
        before(:each) { subject.created_user_name = 'あ' * 64 }

        it { is_expected.to be_valid }
      end

      context '最大長より長い文字が指定されたとき' do
        before(:each) { subject.created_user_name = 'あ' * 65 }

        it { is_expected.not_to be_valid }
      end

      context '「質問者」が指定されるとき' do
        before(:each) { subject.created_user_name = '質問者' }

        it { is_expected.to be_valid }
      end
    end

    describe 'updated_user_name' do
      context '最大長が指定されたとき' do
        before(:each) { subject.updated_user_name = 'あ' * 64 }

        it { is_expected.to be_valid }
      end

      context '最大長より長い文字が指定されたとき' do
        before(:each) { subject.updated_user_name = 'あ' * 65 }

        it { is_expected.not_to be_valid }
      end

      context '「質問者」が指定されるとき' do
        before(:each) { subject.updated_user_name = '質問者' }

        it { is_expected.to be_valid }
      end
    end
  end
end

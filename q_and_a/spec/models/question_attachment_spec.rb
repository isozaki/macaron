# == Schema Information
#
# Table name: question_attachments
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  filename    :string(255)      not null
#  filesize    :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

describe QuestionAttachment do
  describe '検証について' do
    def valid_attributes
      {
        question_id: @question.id,
        filename: 'ファイル名',
        filesize: 1_000
      }
    end

    before(:each) do
      @question = FactoryGirl.create(:question)
      @question_attachment = QuestionAttachment.new(valid_attributes)
    end

    subject { @question_attachment }

    describe '正しい値をセットするとき' do
      it { is_expected.to be_valid }
    end

    describe 'question_id' do
      context 'nilが指定されたとき' do
        before(:each) { subject.question_id = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されたとき' do
        before(:each) { subject.question_id = '' }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'filename' do
      context 'nilが指定されたとき' do
        before(:each) { subject.filename = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されたとき' do
        before(:each) { subject.filename = '' }

        it { is_expected.not_to be_valid }
      end

      context '最大長が指定されたとき' do
        before(:each) { subject.filename = 'あ' * 255 }

        it { is_expected.to be_valid }
      end

      context '最大長より長い文字列が指定されたとき' do
        before(:each) { subject.filename = 'あ' * 256 }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'filesize' do
      context 'nilが指定されたとき' do
        before(:each) { subject.filesize = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されたとき' do
        before(:each) { subject.filesize = '' }

        it { is_expected.not_to be_valid }
      end
    end
  end
end

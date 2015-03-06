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

  describe 'mkdirについて' do
    let(:today) { Date.today }
    let(:path) { 'path' }

    context '指定したパスが存在する場合' do
      before(:each) do
        expect(FileTest).to receive(:exists?).and_return(true)
        expect(File).to receive(:join).and_return(path)
      end

      it 'ディレクトリを作成しないこと' do
        expect(FileUtils).not_to receive(:mkdir_p)
        expect(QuestionAttachment.mkdir(today)).to eq(path)
      end
    end

    context '指定したパスが存在しない場合' do
      before(:each) do
        allow(FileUtils).to receive(:mkdir_p)
        expect(FileTest).to receive(:exists?).and_return(false)
        expect(File).to receive(:join).and_return(path)
      end

      it 'ディレクトリを作成すること' do
        expect(FileUtils).to receive(:mkdir_p)
        expect(QuestionAttachment.mkdir(today)).to eq(path)
      end
    end
  end

  describe 'file_pathについて' do
    let(:path) { 'path' }

    it '正しい値を返すこと' do
      @question_attachment = FactoryGirl.create(:question_attachment)
      expect(File).to receive(:join).and_return(path)
      expect(@question_attachment.file_path).to eq(path)
    end
  end
end

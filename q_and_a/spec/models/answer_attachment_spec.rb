# == Schema Information
#
# Table name: answer_attachments
#
#  id         :integer          not null, primary key
#  answer_id  :integer          not null
#  filename   :string(255)      not null
#  filesize   :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe AnswerAttachment, :type => :model do
  describe '検証について' do
    def valid_attributes
      {
        answer_id: @answer.id,
        filename: 'ファイル名',
        filesize: 1_000
      }
    end

    before(:each) do
      @answer = FactoryGirl.create(:answer)
      @answer_attachment = AnswerAttachment.new(valid_attributes)
    end

    subject { @answer_attachment }

    describe '正しい値をセットするとき' do
      it { is_expected.to be_valid }
    end

    describe 'answer_id' do
      context 'nilが指定されたとき' do
        before(:each) { subject.answer_id = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されたとき' do
        before(:each) { subject.answer_id = '' }

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

      it do
        expect(FileUtils).not_to receive(:mkdir_p)
        expect(AnswerAttachment.mkdir(today)).to eq(path)
      end
    end

    context '指定したパスが存在しない場合' do
      before(:each) do
        allow(FileUtils).to receive(:mkdir_p)
        expect(FileTest).to receive(:exists?).and_return(false)
        expect(File).to receive(:join).and_return(path)
      end

      it '' do
        expect(FileUtils).to receive(:mkdir_p)
        expect(AnswerAttachment.mkdir(today)).to eq(path)
      end
    end
  end

  describe 'file_pathについて' do
    let(:path) { 'path' }
    context '正しい値を返すこと' do
      it '' do
        @answer_attachment = FactoryGirl.create(:answer_attachment)
        expect(File).to receive(:join).and_return(path)
        expect(@answer_attachment.file_path).to eq(path)
      end
    end
  end

  describe 'set_attachmentについて' do
    context '保存成功時' do
      before do
        Answer.delete_all
        @answer = FactoryGirl.create(:answer)
        allow(AnswerAttachment).to receive(:mkdir).and_return('test')
        @attachment_param = double('attachment_param')
        expect(@attachment_param).to receive(:original_filename).and_return('hoge')
        expect(@attachment_param).to receive(:size).and_return(100)
        read_status = double('read_status')
        expect(File).to receive(:open).and_yield(read_status)
        expect(read_status).to receive(:write)
        allow(@attachment_param).to receive(:read)
      end

      it 'DB登録時テーブルの件数が1件増えていること' do
        expect do
          AnswerAttachment.set_attachment(@attachment_param, @answer)
        end.to change { AnswerAttachment.count }.from(0).to(1)
      end

      it '添付ファイルが1件も登録されていないとき、attachment_orderが1となっていること' do
        AnswerAttachment.set_attachment(@attachment_param, @answer)
        expect(AnswerAttachment.count).to eq(1)
      end

      it '添付ファイルが複数あるとき、attachment_orderがmax値+1となっていること' do
        FactoryGirl.create(:answer_attachment,  answer_id: @answer.id)
        AnswerAttachment.set_attachment(@attachment_param, @answer)
        expect(AnswerAttachment.count).to eq(2)
      end

      it '添付ファイル保存処理が呼ばれること' do
        AnswerAttachment.set_attachment(@attachment_param, @answer)
      end
    end

    context '保存失敗時' do
      it 'CreateAttachmentErrorが呼ばれること' do
        @answer = FactoryGirl.create(:answer)
        answer_attachment = FactoryGirl.build(:answer_attachment, filesize: 10_000_000)
        allow(@answer).to receive(:answer_attachment).and_return(answer_attachment)
        attachment_param = double('attachment_param')
        expect(attachment_param).to receive(:original_filename).and_return('hoge')
        expect(attachment_param).to receive(:size).and_return(100)
        expect do
          AnswerAttachment.set_attachment(attachment_param, @answer)
        end.to raise_error
      end
    end
  end
end

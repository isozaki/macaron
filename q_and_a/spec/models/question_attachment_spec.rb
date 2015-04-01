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

      it do
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

      it '' do
        expect(FileUtils).to receive(:mkdir_p)
        expect(QuestionAttachment.mkdir(today)).to eq(path)
      end
    end
  end

  describe 'file_pathについて' do
    let(:path) { 'path' }
    context '正しい値を返すこと' do
      it '' do
        @question_attachment = FactoryGirl.create(:question_attachment)
        expect(File).to receive(:join).and_return(path)
        expect(@question_attachment.file_path).to eq(path)
      end
    end
  end

  describe 'set_attachmentについて' do
    context '保存成功時' do
      before do
        Question.delete_all
        @question = FactoryGirl.create(:question)
        allow(QuestionAttachment).to receive(:mkdir).and_return('test')
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
          QuestionAttachment.set_attachment(@attachment_param, @question)
        end.to change { QuestionAttachment.count }.from(0).to(1)
      end

      it '添付ファイルが1件も登録されていないとき、attachment_orderが1となっていること' do
        QuestionAttachment.set_attachment(@attachment_param, @question)
        expect(QuestionAttachment.count).to eq(1)
      end

      it '添付ファイルが複数あるとき、attachment_orderがmax値+1となっていること' do
        FactoryGirl.create(:question_attachment,  question_id: @question.id)
        QuestionAttachment.set_attachment(@attachment_param, @question)
        expect(QuestionAttachment.count).to eq(2)
      end

      it '添付ファイル保存処理が呼ばれること' do
        QuestionAttachment.set_attachment(@attachment_param, @question)
      end
    end

    context '保存失敗時' do
      it 'CreateAttachmentErrorが呼ばれること' do
        @question = FactoryGirl.create(:question)
        question_attachment = FactoryGirl.build(:question_attachment, filesize: 10_000_000)
        allow(@question).to receive(:question_attachment).and_return(question_attachment)
        attachment_param = double('attachment_param')
        expect(attachment_param).to receive(:original_filename).and_return('hoge')
        expect(attachment_param).to receive(:size).and_return(100)
        expect do
          QuestionAttachment.set_attachment(attachment_param, @question)
        end.to raise_error
      end
    end
  end
end

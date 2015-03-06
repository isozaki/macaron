require 'rails_helper'

describe QuestionAttachmentsController do
  before(:each) do
    skip
  end
  describe "POST 'create'" do
    before do
      @question = FactoryGirl.create(:question)
    end

    context 'ファイルが選択されているとき' do
      before do
        expect(QuestionAttachment).to receive(:set_attachment)
        allow(Question).to receive_message_chain(:includes, :find_by_id).and_return(@question)
        post :create, question_id: @question.id, attachment: 'attachment'
      end

      it '正常に処理が終了すること' do
        expect(response).to redirect_to(manage_question_path(@question.id))
      end
    end

    context 'エラー時の処理' do
      context 'validateに引っかかる場合' do
        it '適切なエラーログが出力されること' do
          expect(QuestionAttachment).to receive(:set_attachment).and_raise(CreateAttachmentError)
          allow(Question).to receive_message_chain(:includes, :find_by_id).and_return(@question)

          post :create, question_id: @question.id, attachment: 'attachment'
        end
      end

      context 'エラーが発生した場合' do
        it '適切なエラーログが出力されること' do
          expect(QuestionAttachment).to receive(:set_attachment).and_raise

          post :create, question_id: @question.id, attachment: 'attachment'
        end
      end
    end

    context 'ファイルが選択されていないとき' do
      it 'アップロード処理を行わないこと' do
        expect(QuestionAttachment).not_to receive(:set_attachment)
        allow(Question).to receive_message_chain(:includes, :find_by_id).and_return(@question)

        post :create, question_id: @question.id
      end

      it '正常に処理が終了すること' do
        post :create, question_id: @question.id

        expect(response).to redirect_to(manage_question_path(@question.id))
      end
    end
  end
end

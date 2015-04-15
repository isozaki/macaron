require 'rails_helper'

RSpec.describe AnswerAttachmentsController, :type => :controller do
  before(:each) do
    logined_by(mock_logined_user)
  end

  describe "GET 'show'" do
    before do
      @question = FactoryGirl.create(:question)
      @answer = FactoryGirl.create(:answer)
      @answer_attachment = FactoryGirl.create(:answer_attachment)
    end

    context 'ダウンロード処理が成功した場合' do
      it 'エラー処理が行われないこと' do
        expect(controller).to receive(:send_file)
        allow(controller).to receive(:render)
        get :show, question_id: @question.id, answer_id: @answer.id, id: @answer_attachment.id
      end
    end

    context 'ダウンロードが失敗した場合' do
      it '正常に処理が終了すること' do
        expect(AnswerAttachment).to receive(:find_by_id).and_raise
        get :show, question_id: @question.id, answer_id: @answer.id, id: @answer_attachment.id
        expect(response).to redirect_to(question_path(@question))
        
        expect(flash[:alert]).to eq 'ダウンロードに失敗しました'
      end
    end
  end

  describe "POST 'create'" do
    before do
      @question = FactoryGirl.create(:question)
      @answer = FactoryGirl.create(:answer)
    end

    context 'ファイルが選択されているとき' do
      before do
        expect(AnswerAttachment).to receive(:set_attachment)
        allow(Answer).to receive(:find_by_id).and_return(@answer)
        allow(Question).to receive(:find_by_id).and_return(@question)
        post :create, question_id: @question.id, answer_id: @answer.id, attachment: 'attachment'
      end

      it '正常に処理が終了すること' do
        expect(response).to redirect_to(question_path(@question))
      end
    end

    context 'エラー時の処理' do
      context 'エラーが発生した場合' do
        it 'エラーメッセージが表示されること' do
          expect(AnswerAttachment).to receive(:set_attachment).and_raise
          post :create, question_id: @question.id,  answer_id: @answer.id, attachment: 'attachment'
          expect(flash[:alert]).to eq 'ファイルの添付に失敗しました'
        end
      end
    end

    context 'ファイルが選択されていないとき' do
      it 'アップロード処理を行わないこと' do
        expect(AnswerAttachment).not_to receive(:set_attachment)
        allow(Answer).to receive(:find_by_id).and_return(@answer)
        allow(Question).to receive(:find_by_id).and_return(@question)
        post :create, question_id: @question.id, answer_id: @answer.id
        expect(flash[:alert]).to eq 'ファイルの添付に失敗しました'
      end
    end
  end

  describe "DELETE 'destroy'" do
    before do
      @question = FactoryGirl.create(:question)
      @answer = FactoryGirl.create(:answer)
      @answer_attachment = FactoryGirl.create(:answer_attachment)
    end

    context '削除に成功した場合' do
      before do
        allow(Answer).to receive(:find_by_id).and_return(@answer)
        allow(Question).to receive(:find_by_id).and_return(@question)
        allow(AnswerAttachment).to receive(:find_by_id).and_return(@answer_attachment)
      end

      it '正常に処理が終了すること' do
        delete :destroy, question_id: @question.id, answer_id: @answer.id, id: @answer_attachment.id
        expect(response).to redirect_to(question_path(@question))
      end

      it '削除処理が行われること' do
        expect(@answer_attachment).to receive(:destroy)
        delete :destroy, question_id: @question.id, answer_id: @answer.id, id: @answer_attachment.id
      end
    end

    context '削除に失敗した場合' do
      it '正常に処理が終了すること' do
        expect(AnswerAttachment).to receive(:find_by_id).and_raise
        delete :destroy, question_id: @question.id, answer_id: @answer.id, id: @answer_attachment.id
        expect(response).to redirect_to(question_path(@question))
      end
    end
  end
end

require 'rails_helper'

describe AnswersController do

  describe "GET new" do
    before(:each) do
      @answer = mock_model(Answer)
      expect(Answer).to receive(:new).and_return(@answer)

      get :new, question_id: 1
    end

    it '質問新規登録画面を呼び出すこと' do
      expect(response).to render_template(:new)
    end

    it '新規レコード用の@questionが設定されること' do
      expect(assigns(:answer)).to be @answer
    end
  end

  describe "POST create" do
    before(:each) do
      @answer = mock_model(Answer, question: @question)

      allow(Answer).to receive(:new).and_return(@answer)
    end

    context '回答の登録に成功するとき' do
      before(:each) do
        @question = mock_model(Question, id: 1)

        expect(Answer).to receive(:new).with(
          'answer' => '回答',
          'created_user_name' => '回答者',
        ).and_return(@answer)
        expect(@answer).to receive(:question_id=).and_return(@question.id)
        expect(@answer).to receive(:save!)
        allow(Question).to receive(:find_by_id).and_return(@question)

        post :create, question_id: @question.id, answer: {
          'answer' => '回答',
          'created_user_name' => '回答者'
        }
      end

      it 'ステータス変更画面にリダイレクトされること' do
        expect(response).to redirect_to(edit_status_question_url(@question))
      end
    end

    context '回答の登録に失敗するとき' do
      before(:each) do
        @question = mock_model(Question, id: 1)
        expect(@answer).to receive(:valid?).and_return false
        expect(@answer).to receive(:question_id=).and_return(@question.id)

        post :create, question_id: @question.id, answer: { answer: '回答' }
      end

      it 'newを再描画すること' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET edit" do
  end
end

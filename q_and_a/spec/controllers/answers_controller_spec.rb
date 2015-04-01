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
    before(:each) do
      @question = mock_model(Question, id: 1)
      allow(Question).to receive(:find_by_id).and_return(@question)
      @answer = mock_model(Answer, id: 1)
      @answers = []
    end

    context '対象が指定されていないとき' do
      before(:each) do
        get :edit, question_id: @question.id, id: ''
      end

      it '質問詳細画面が表示されること' do
        expect(response).to redirect_to(question_url(@question))
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が指定されていません'
      end
    end

    context '対象が存在しないとき' do
      before(:each) do
        expect(Answer).to receive(:where).with(id: 0.to_s).and_return(@answers)
        expect(@answers).to receive(:first).and_return(nil)

        get :edit, question_id: @question.id, id: 0
      end

      it '質問一覧画面が表示されること' do
        expect(response).to redirect_to(question_url(@question))
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が見つかりません'
      end
    end

    context '対象が存在するとき' do
      before(:each) do
        expect(Answer).to receive(:where).with(id: @answer.id.to_s).and_return(@answers)
        expect(@answers).to receive(:first).and_return(@answer)

        get :edit, question_id: @question.id, id: @answer.id
      end

      it '質問編集画面が表示されること' do
        expect(response).to render_template(:edit)
      end

      it { expect(assigns(:answer)).to eq @answer }
    end
  end

  describe "PATAH update" do
    before(:each) do
      @question = mock_model(Question, id: 1)
      allow(Question).to receive(:find_by_id).and_return(@question)
      @answer = mock_model(Answer, id: 1)
    end

    context '成功するとき' do
      before(:each) do
        allow(Answer).to receive_message_chain(:where, :first).and_return(@answer)
        expect(@answer).to receive(:update!)
          .with('answer' => '回答',
                'updated_user_name' => '更新者A')

          patch(:update, question_id: @question.id,  id: @answer.id, answer: {
          answer: '回答',
          updated_user_name: '更新者A'
        })
      end

      it 'ステータス変更画面へ遷移すること' do
        expect(response).to redirect_to(edit_status_question_url(@question))
      end

      it { expect(flash[:notice]).to eq '回答を更新しました' }
    end

    context '失敗するとき' do
      before(:each) do
        allow(Answer).to receive_message_chain(:where, :first).and_return(@answer)
        expect(@answer).to receive(:update!)
          .with('answer' => '回答',
                'updated_user_name' => '更新者A')
          .and_raise(ActiveRecord::RecordInvalid.new(@question))

        patch(:update, question_id: @question.id, id: @answer.id, answer: {
          answer: '回答',
          updated_user_name: '更新者A'
        })
      end

      it '質問編集画面を再表示すること' do
        expect(response).to render_template(:edit)
      end

      it { expect(assigns(:answer)).to eq @answer }
    end

    context '対象が指定されていないとき' do
      before(:each) do

        patch(:update, question_id: @question.id,  id: '', answer: {
          answer: '回答',
          updated_user_name: '更新者'
        })
      end

      it '質問詳細画面に遷移すること' do
        expect(response).to redirect_to(question_url(@question))
      end

      it { expect(flash[:alert]).to eq '対象が指定されていません' }
    end

    context '対象が存在しないとき' do
      before(:each) do
        allow(Answer).to receive_message_chain(:where, :first).and_return(nil)

        patch(:update, question_id: @question.id, id: '0', answer: {
            answer: '回答',
            updated_user_name: '更新者A'
        })
      end

      it '質問詳細画面に遷移すること' do
        expect(response).to redirect_to(question_url(@question))
      end

      it { expect(flash[:alert]).to eq '対象が見つかりません' }
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      @question = mock_model(Question, id: 1)
      expect(Question).to receive(:find_by_id).and_return(@question)
      @answer = mock_model(Answer, id: 1)
      @answer_attachment = mock_model(AnswerAttachment)
    end

    context '成功するとき' do
      before(:each) do
        expect(Answer).to receive(:find_by_id).and_return @answer
        allow(@answer).to receive(:answer_attachment).and_return @answer_attachment
        expect(@answer_attachment).to receive(:destroy)

        delete :destroy, question_id: @question.id, id: @answer.id
      end

      it '質問詳細画面にリダイレクトされること' do
        expect(response).to redirect_to(question_url(@question))
      end

      it '削除完了メッセージが表示されること' do
        expect(flash[:notice]).to eq('回答を削除しました')
      end
    end

    context '失敗するとき' do
      before(:each) do
        expect(Answer).to receive(:find_by_id).and_return @answer
        expect(@answer).to receive(:destroy).and_raise

        delete :destroy, question_id: @question.id, id: @answer.id
      end

      it '質問一覧画面に遷移すること' do
        expect(response).to redirect_to(question_url(@answer))
      end

      it { expect(flash[:alert]).to eq('質問の削除に失敗しました') }
    end
  end
end

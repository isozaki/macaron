require 'rails_helper'

RSpec.describe QuestionsController, :type => :controller do

  describe "GET index" do
    before(:each) do
      @questions = double
      expect(Question).to receive(:search_question)
        .with(hash_including('title' => 'タイトル1'))
        .and_return @questions

      get :index, title: 'タイトル1'
    end

    it { expect(response).to render_template(:index) }
    it { expect(assigns(:questions)).to eq @questions }
  end

  describe "GET show" do
    before(:each) do
      @question = mock_model(Question)
      @questions = []
    end

    context '対象が指定されていないとき' do
      before(:each) do
        get :show, id: ''
      end

      it '質問一覧画面が表示されること' do
        expect(response).to redirect_to(questions_url)
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が指定されていません'
      end
    end

    context '対象が存在しないとき' do
      before(:each) do
        allow(Question).to receive(:where).with(id: 0.to_s).and_return(@questions)
        expect(@questions).to receive(:first).and_return(nil)

        get :show, id: 0
      end

      it '質問一覧画面が表示されること' do
        expect(response).to redirect_to(questions_url)
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が見つかりません'
      end
    end

    context '対象が存在するとき' do
      before(:each) do
        allow(Question).to receive(:where).with(id: @question.id.to_s).and_return(@questions)
        expect(@questions).to receive(:first).and_return(@question)

        get :show, id: @question.id
      end

      it '質問詳細画面が表示されること' do
        expect(response).to render_template(:show)
      end

      it { expect(assigns(:question)).to eq @question }
    end
  end

  describe "GET new" do
    before(:each) do
      @question = mock_model(Question)
      expect(Question).to receive(:new).and_return(@question)

      get :new
    end

    it '質問新規登録画面を呼び出すこと' do
      expect(response).to render_template(:new)
    end

    it '新規レコード用の@questionが設定されること' do
      expect(assigns(:question)).to be @question
    end
  end

  describe "POST create" do
    before(:each) do
      @question = mock_model(Question)

      allow(Question).to receive(:new).and_return(@question)
    end

    context '質問の登録に成功するとき' do
      before(:each) do
        expect(Question).to receive(:new).with(
          'title' => 'タイトル',
          'question' => '質問',
          'charge' => '担当者',
          'priority' => '2',
          'limit_datetime' => 1.days.since.strftime('%Y%m%d'),
          'created_user_name' => '質問者',
        ).and_return(@question)
        expect(@question).to receive(:save!)

        post :create, question: {
          'title' => 'タイトル',
          'question' => '質問',
          'charge' => '担当者',
          'priority' => '2',
          'limit_datetime' => 1.days.since.strftime('%Y%m%d'),
          'created_user_name' => '質問者',
        }
      end

      it 'showにリダイレクトされること' do
        expect(response).to redirect_to(question_url(@question))
      end

      it '登録成功のメッセージが表示されること' do
        expect(flash[:notice]).to eq('質問を登録しました')
      end
    end

    context '質問の登録に失敗するとき' do
      before(:each) do
        expect(@question).to receive(:valid?).and_return false

        post :create, question: { title: 'タイトル' }
      end

      it 'newを再描画すること' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET edit" do
  end
end

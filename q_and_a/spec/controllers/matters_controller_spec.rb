require 'rails_helper'

RSpec.describe MattersController, :type => :controller do

  describe "GET index" do
  end

  describe "GET show" do
  end

  describe "GET new" do
    before(:each) do
      logined_by(mock_logined_user)
      @matter = mock_model(Matter)
      expect(Matter).to receive(:new).and_return(@matter)

      get :new
    end

    it '案件新規登録画面を呼び出すこと' do
      expect(response).to render_template(:new)
    end

    it '新規レコード用の@matterが設定されること' do
      expect(assigns(:matter)).to be @matter
    end
  end

  describe "POST create" do
    before(:each) do
      logined_by(mock_logined_user)
      @matter = mock_model(Matter)

      allow(Matter).to receive(:new).and_return(@matter)
    end

    context '利用者の登録に成功するとき' do
      before(:each) do
        expect(Matter).to receive(:new).with('title' => 'タイトル').and_return(@matter)
        expect(@matter).to receive(:save!)

        post :create, matter: { 'title' => 'タイトル' }
      end

      it 'showにリダイレクトされること' do
        expect(response).to redirect_to(matter_url(@matter))
      end

      it '登録成功のメッセージが表示されること' do
        expect(flash[:notice]).to eq('案件を登録しました')
      end
    end

    context '利用者の登録に失敗するとき' do
      before(:each) do
        expect(@matter).to receive(:valid?).and_return false

        post :create, matter: { title: '' }
      end

      it 'newを再描画すること' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET edit" do
  end
end

require 'rails_helper'

RSpec.describe UsersController, :type => :controller do

  describe "GET index" do
    before(:each) do
      @users = double
      expect(User).to receive(:search_user)
        .with(hash_including('name' => 'テスト太郎'))
        .and_return @users

      get :index, name: 'テスト太郎'
    end

    it { expect(response).to render_template(:index) }
    it { expect(assigns(:users)).to eq @users }
  end

  describe "GET new" do
    before(:each) do
      @user = mock_model(User)
      expect(User).to receive(:new).and_return(@user)

      get :new
    end

    it '利用者新規登録画面を呼び出すこと' do
      expect(response).to render_template(:new)
    end

    it '新規レコード用の@userが設定されること' do
      expect(assigns(:user)).to be @user
    end
  end

  describe "POST create" do
    before(:each) do
      @user = mock_model(User)

      allow(User).to receive(:new).and_return(@user)
    end

    context '利用者の登録に成功するとき' do
      before(:each) do
        expect(User).to receive(:new).with(
          'name' => 'テスト太郎',
          'name_kana' => 'テストタロウ',
          'login' => 'login',
          'password' => 'password',
        ).and_return(@user)
        expect(@user).to receive(:save!)

        post :create, user: {
          'name' => 'テスト太郎',
          'name_kana' => 'テストタロウ',
          'login' => 'login',
          'password' => 'password'
        }
      end

      it 'indexにリダイレクトされること' do
        expect(response).to redirect_to(users_url)
      end

      it '登録成功のメッセージが表示されること' do
        expect(flash[:notice]).to eq('利用者を登録しました')
      end
    end

    context '利用者の登録に失敗するとき' do
      before(:each) do
        expect(@user).to receive(:valid?).and_return false

        post :create, user: { name: 'テスト太郎' }
      end

      it 'newを再描画すること' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET edit" do
  end

  describe "GET login" do
  end
end

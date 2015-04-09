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

  describe "GET show" do
    before(:each) do
      @user = mock_model(User)
      @users = []
    end

    context '対象が指定されていないとき' do
      before(:each) do
        get :show, id: ''
      end

      it '利用者一覧画面が表示されること' do
        expect(response).to redirect_to(users_url)
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が指定されていません'
      end
    end

    context '対象が存在しないとき' do
      before(:each) do
        allow(User).to receive(:where).with(id: 0.to_s).and_return(@users)
        expect(@users).to receive(:first).and_return(nil)

        get :show, id: 0
      end

      it '利用者一覧画面が表示されること' do
        expect(response).to redirect_to(users_url)
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が見つかりません'
      end
    end

    context '対象が存在するとき' do
      before(:each) do
        allow(User).to receive(:where).with(id: @user.id.to_s).and_return(@users)
        expect(@users).to receive(:first).and_return(@user)

        get :show, id: @user.id
      end

      it '利用者詳細画面が表示されること' do
        expect(response).to render_template(:show)
      end

      it { expect(assigns(:user)).to eq @user }
    end
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
    before(:each) do
      @user = mock_model(User, id: 1)
      @users = []
    end

    context '対象が指定されていないとき' do
      before(:each) do
        get :edit, id: ''
      end

      it '利用者一覧画面が表示されること' do
        expect(response).to redirect_to(users_url)
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が指定されていません'
      end
    end

    context '対象が存在しないとき' do
      before(:each) do
        expect(User).to receive(:where).with(id: 0.to_s).and_return(@users)
        expect(@users).to receive(:first).and_return(nil)

        get :edit, id: 0
      end

      it '利用者一覧画面が表示されること' do
        expect(response).to redirect_to(users_url)
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が見つかりません'
      end
    end

    context '対象が存在するとき' do
      before(:each) do
        expect(User).to receive(:where).with(id: @user.id.to_s).and_return(@users)
        expect(@users).to receive(:first).and_return(@user)

        get :edit, id: @user.id
      end

      it '質問編集画面が表示されること' do
        expect(response).to render_template(:edit)
      end

      it { expect(assigns(:user)).to eq @user }
    end
  end

  describe "PATCH update" do
    before(:each) do
      @user = mock_model(User, id: 1)
    end

    context '成功するとき' do
      before(:each) do
        allow(User).to receive_message_chain(:where, :first).and_return(@user)
        expect(@user).to receive(:update!)
          .with('name' => 'テスト太郎',
                'name_kana' => 'テストタロウ')

        patch(:update, id: @user.id, user: {
          name: 'テスト太郎',
          name_kana: 'テストタロウ'
        })
      end

      it '利用者詳細画面へ遷移すること' do
        expect(response).to redirect_to(user_url(@user))
      end

      it { expect(flash[:notice]).to eq '利用者を更新しました' }
    end

    context '失敗するとき' do
      before(:each) do
        allow(User).to receive_message_chain(:where, :first).and_return(@user)
        expect(@user).to receive(:update!)
          .with('name' => 'テスト太郎',
                'name_kana' => 'テストタロウ')
          .and_raise(ActiveRecord::RecordInvalid.new(@user))

        patch(:update, id: @user.id, user: {
          name: 'テスト太郎',
          name_kana: 'テストタロウ'
        })
      end

      it '利用者編集画面を再表示すること' do
        expect(response).to render_template(:edit)
      end

      it { expect(assigns(:user)).to eq @user }
    end

    context '対象が指定されていないとき' do
      before(:each) do

        patch(:update, id: '', user: {
          name: 'テスト太郎',
          name_kana: 'テストタロウ'
        })
      end

      it '質問一覧画面に遷移すること' do
        expect(response).to redirect_to(users_url)
      end

      it { expect(flash[:alert]).to eq '対象が指定されていません' }
    end

    context '対象が存在しないとき' do
      before(:each) do
        allow(User).to receive_message_chain(:where, :first).and_return(nil)

        patch(:update, id: '0', user: {
            name: 'テスト太郎',
            name_kana: 'テストタロウ'
        })
      end

      it '質問一覧画面に遷移すること' do
        expect(response).to redirect_to(users_url)
      end

      it { expect(flash[:alert]).to eq '対象が見つかりません' }
    end
  end

  describe "GET login" do
  end
end

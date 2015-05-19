require 'rails_helper'

RSpec.describe MattersController, :type => :controller do
  before(:each) do
    logined_by(mock_logined_user)
  end

  describe "GET index" do
    before(:each) do
      @matters = double
      expect(Matter).to receive(:search_matter)
        .with(hash_including('title' => 'タイトル'))
        .and_return @matters

      get :index, title: 'タイトル'
    end

    it { expect(response).to render_template(:index) }
    it { expect(assigns(:matters)).to eq @matters }
  end

  describe "GET show" do
    before(:each) do
      @matter = mock_model(Matter)
      @matters = [@matter]
    end

    context '対象が指定されていないとき' do
      before(:each) do
        get :show, id: ''
      end

      it '案件一覧画面が表示されること' do
        expect(response).to redirect_to(matters_url)
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が指定されていません'
      end
    end

    context '対象が存在しないとき' do
      before(:each) do
        allow(Matter).to receive(:where).with(id: 0.to_s).and_return(@matters)
        expect(@matters).to receive(:first).and_return(nil)

        get :show, id: 0
      end

      it '案件一覧画面が表示されること' do
        expect(response).to redirect_to(matters_url)
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が見つかりません'
      end
    end

    context '対象が存在するとき' do
      before(:each) do
        @user = mock_model(User)
        @matter_user = mock_model(MatterUser, matter: @matter, user: @user)
        @matter_users = [@matter_user]

        allow(Matter).to receive(:where).with(id: @matter.id.to_s).and_return(@matters)
        expect(@matters).to receive(:first).and_return(@matter)
        allow(MatterUser).to receive(:where).with(matter_id: @matter.id.to_s).and_return @matter_users

        get :show, id: @matter.id
      end

      it '案件詳細画面が表示されること' do
        expect(response).to render_template(:show)
      end

      it { expect(assigns(:matter)).to eq @matter }
    end
  end

  describe "GET new" do
    before(:each) do
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
    before(:each) do
      @matter = mock_model(Matter, id: 1)
      @matters = []
    end

    context '対象が指定されていないとき' do
      before(:each) do
        get :edit, id: ''
      end

      it '案件一覧画面が表示されること' do
        expect(response).to redirect_to(matters_url)
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が指定されていません'
      end
    end

    context '対象が存在しないとき' do
      before(:each) do
        expect(Matter).to receive(:where).with(id: 0.to_s).and_return(@matters)
        expect(@matters).to receive(:first).and_return(nil)

        get :edit, id: 0
      end

      it '案件一覧画面が表示されること' do
        expect(response).to redirect_to(matters_url)
      end

      it 'アラートが表示されること' do
        expect(flash[:alert]).to eq '対象が見つかりません'
      end
    end

    context '対象が存在するとき' do
      before(:each) do
        expect(Matter).to receive(:where).with(id: @matter.id.to_s).and_return(@matters)
        expect(@matters).to receive(:first).and_return(@matter)

        get :edit, id: @matter.id
      end

      it '案件編集画面が表示されること' do
        expect(response).to render_template(:edit)
      end

      it { expect(assigns(:matter)).to eq @matter }
    end
  end

  describe "PATCH update" do
    before(:each) do
      @matter = mock_model(Matter, id: 1)
    end

    context '成功するとき' do
      before(:each) do
        allow(Matter).to receive_message_chain(:where, :first).and_return(@matter)
        expect(@matter).to receive(:update!).with('title' => 'タイトル')

        patch(:update, id: @matter.id, matter: { title: 'タイトル' })
      end

      it '案件詳細画面へ遷移すること' do
        expect(response).to redirect_to(matter_url(@matter))
      end

      it { expect(flash[:notice]).to eq '案件を更新しました' }
    end

    context '失敗するとき' do
      before(:each) do
        allow(Matter).to receive_message_chain(:where, :first).and_return(@matter)
        expect(@matter).to receive(:update!).with('title' => 'タイトル')
          .and_raise(ActiveRecord::RecordInvalid.new(@matter))

        patch(:update, id: @matter.id, matter: { title: 'タイトル' })
      end

      it '案件編集画面を再表示すること' do
        expect(response).to render_template(:edit)
      end

      it { expect(assigns(:matter)).to eq @matter }
    end

    context '対象が指定されていないとき' do
      before(:each) do

        patch(:update, id: '', matter: { title: 'タイトル' })
      end

      it '案件一覧画面に遷移すること' do
        expect(response).to redirect_to(matters_url)
      end

      it { expect(flash[:alert]).to eq '対象が指定されていません' }
    end

    context '対象が存在しないとき' do
      before(:each) do
        allow(Matter).to receive_message_chain(:where, :first).and_return(nil)

        patch(:update, id: '0', matter: { title: 'タイトル' })
      end

      it '案件一覧画面に遷移すること' do
        expect(response).to redirect_to(matters_url)
      end

      it { expect(flash[:alert]).to eq '対象が見つかりません' }
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      @matter = mock_model(Matter, id: 1)
    end

    context '成功するとき' do
      before(:each) do
        expect(Matter).to receive(:find_by_id).and_return @matter

        delete :destroy, id: @matter.id
      end

      it '案件一覧画面にリダイレクトされること' do
        expect(response).to redirect_to(matters_url)
      end

      it '削除完了メッセージが表示されること' do
        expect(flash[:notice]).to eq('案件を削除しました')
      end
    end

    context '失敗するとき' do
      before(:each) do
        expect(Matter).to receive(:find_by_id).and_return @matter
        expect(@matter).to receive(:destroy).and_raise

        delete :destroy, id: @matter.id
      end

      it '案件一覧画面に遷移すること' do
        expect(response).to redirect_to(matters_url)
      end

      it { expect(flash[:alert]).to eq('案件の削除に失敗しました') }
    end
  end

  describe 'POST add_user' do
    before(:each) do
      @user1 = mock_model(User, id: 1)
      @user2 = mock_model(User, id: 2)
      @matter = mock_model(Matter, id: 1)
      @matter_user = mock_model(MatterUser)
      @users = [@user1, @user2]

      MatterUser.delete_all
    end

    context '参加者の追加に成功するとき' do
      before(:each) do
        allow(Matter).to receive_message_chain(:where, :first).and_return @matter

        expect(User).to receive(:where).with('id = ?', '1').and_return @users
        expect(@users).to receive(:first).and_return @user1

        expect(MatterUser).to receive(:new)
          .with(user_id: @user1.id, matter_id: @matter.id)
          .and_return @matter_user
        expect(@matter_user).to receive(:save!)

        post :add_user, id: @matter.id, user_id: @user1.id
      end

      it 'showにリダイレクトされること' do
        expect(response).to redirect_to(matter_url(@matter))
      end

      it 'noticeに追加完了メッセージが設定されること' do
        expect(flash[:notice]).to eq('参加者を追加しました。')
      end
    end

    context '存在しない利用者を指定するとき' do
      before(:each) do
        allow(Matter).to receive_message_chain(:where, :first).and_return @matter
        expect(User).to receive(:where).with('id = ?', '1').and_return @users
        expect(@users).to receive(:first).and_return nil

        post :add_user, id: @matter.id, user_id: @user1.id
      end

      it '利用者追加画面にリダイレクトされること' do
        expect(response).to redirect_to(new_user_matter_url(@matter))
      end

      it 'alertにエラーメッセージが設定されること' do
        expect(flash[:alert]).to eq('対象の参加者が見つかりません。')
      end
    end

    context '存在しない案件を指定するとき' do
      before(:each) do
        allow(Matter).to receive_message_chain(:where, :first).and_return nil

        post :add_user, id: @matter.id, user_id: @user1.id
      end

      it '案件一覧画面にリダイレクトされること' do
        expect(response).to redirect_to(matters_path)
      end

      it 'alertにエラーメッセージが設定されること' do
        expect(flash[:alert]).to eq('対象の案件が見つかりません。')
      end
    end
  end

  describe 'GET new_user' do
    before(:each) do
      @matter = mock_model(Matter, id: 1)
      @user = mock_model(User, id: 1)
      @users = [ @user ]
      @matter_user = mock_model(MatterUser)

      expect(MatterUser).to receive(:new).and_return(@matter_user)
      expect(User).to receive(:search_user).and_return @users

      get :new_user, id: 1
    end

    it '利用者新規登録画面を呼び出すこと' do
      expect(response).to render_template(:new_user)
    end

    it '新規レコード用の@matter_userが設定されること' do
      expect(assigns(:matter_user)).to be @matter_user
    end
  end

  describe 'DELETE remove_user' do
    before(:each) do
      @matter = mock_model(Matter, id: 1)
      @user = mock_model(User, id:1)
      @matter_user = mock_model(MatterUser, matter: @matter, user: @user)
    end

    context '成功するとき' do
      before(:each) do
        allow(Matter).to receive_message_chain(:where, :first).and_return @matter

        expect(MatterUser).to receive(:find_by_id).and_return @matter_user
        expect(@matter_user).to receive(:destroy)

        delete :remove_user, id: @matter.id, matter_user_id: @matter_user.id
      end

      it '案件詳細画面にリダイレクトされること' do
        expect(response).to redirect_to(matter_path(@matter))
      end

      it '削除完了メッセージが表示されること' do
        expect(flash[:notice]).to eq('参加者を削除しました。')
      end
    end

    context '失敗するとき' do
      before(:each) do
        allow(Matter).to receive_message_chain(:where, :first).and_return @matter

        expect(MatterUser).to receive(:find_by_id).and_return @matter_user
        expect(@matter_user).to receive(:destroy).and_raise

        delete :remove_user, id: @matter.id, matter_user_id: @matter_user.id
      end

      it '案件詳細画面に遷移すること' do
        expect(response).to redirect_to(matter_path(@matter))
      end

      it { expect(flash[:alert]).to eq('参加者の削除に失敗しました。') }
    end

    context '存在しない参加者のを指定するとき' do
      before(:each) do
        allow(Matter).to receive_message_chain(:where, :first).and_return @matter

        expect(MatterUser).to receive(:find_by_id).and_return nil

        delete :remove_user, id: @matter.id, matter_user_id: @matter_user.id
      end

      it '案件詳細画面に遷移すること' do
        expect(response).to redirect_to(matter_path(@matter))
      end

      it { expect(flash[:alert]).to eq('対象の参加者が見つかりません。') }
    end
  end
end

require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

  describe "GET index" do
  end

  describe "GET new" do
  end

  describe 'POST create' do
    before(:each) do
      @user = FactoryGirl.create(:user, login: 'login', password: 'password')
    end

    context 'ログインに成功するとき' do
      before(:each) do
        expect(User).to receive(:find_by_login).with('login') .and_return(@user)
        expect(@user).to receive(:authenticate).with('password').and_return(@user)

        post :create, login: 'login', pass: 'password'
      end

      it 'メニュー画面へリダイレクトされること' do
        expect(response).to redirect_to(menus_url)
      end

      it {expect(flash[:notice]).to eq 'ログインしました'}
    end

    context '不正なログインIDを入力するとき' do
      before(:each) do
        expect(User).to receive(:find_by_login).with('').and_return nil

        post :create, login: '', pass: 'password'
      end

      it 'ログイン画面を再表示すること' do
        expect(response).to redirect_to(new_session_url)
      end

      it {expect(flash[:alert]).to eq 'ログインに失敗しました'}
    end

    context  'ログインに失敗するとき' do
      before(:each) do
        expect(User).to receive(:find_by_login).with('login').and_return(@user)
        expect(@user).to receive(:authenticate).with('').and_return nil

        post :create, login: 'login', pass: ''
      end

      it 'ログイン画面を再表示すること' do
        expect(response).to redirect_to(new_session_url)
      end

      it {expect(flash[:alert]).to eq 'ログインに失敗しました'}
    end
  end
end

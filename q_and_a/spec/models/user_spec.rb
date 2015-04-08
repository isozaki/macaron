# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(64)       not null
#  name_kana  :string(64)       not null
#  login      :string(255)      not null
#  password   :string(16)       not null
#  deleted    :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  describe '検証について' do
    def valid_attributes
      {
        name: 'テスト太郎',
        name_kana: 'テストタロウ',
        login: 'login',
        password: 'password'
      }
    end

  before(:each) do
    @user = User.new(valid_attributes)
  end

    subject { @user }

    describe '正しい値をセットするとき' do
      it { is_expected.to be_valid }
    end

    describe 'name' do
      context 'nilが指定されたとき' do
        before(:each) { subject.name = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されたとき' do
        before(:each) { subject.name = '' }

        it { is_expected.not_to be_valid }
      end

      context '最大長が指定されたとき' do
        before(:each) { subject.name = 'あ' * 64 }

        it { is_expected.to be_valid }
      end

      context '最大長より長い文字列が指定されたとき' do
        before(:each) { subject.name = 'あ' * 65 }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'name_kana' do
      context 'nilが指定されたとき' do
        before(:each) { subject.name_kana = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されたとき' do
        before(:each) { subject.name_kana = '' }

        it { is_expected.not_to be_valid }
      end

      context '最大長が指定されたとき' do
        before(:each) { subject.name_kana = 'あ' * 64 }

        it { is_expected.to be_valid }
      end

      context '最大長より長い文字列が指定されたとき' do
        before(:each) { subject.name_kana = 'あ' * 65 }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'login' do
      context 'nilが指定されたとき' do
        before(:each) { subject.login = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されたとき' do
        before(:each) { subject.login = '' }

        it { is_expected.not_to be_valid }
      end

      context '最大長が指定されたとき' do
        before(:each) { subject.login = 'a' * 255 }

        it { is_expected.to be_valid }
      end

      context '最大長より長い文字列が指定されたとき' do
        before(:each) { subject.login = 'a' * 256 }

        it { is_expected.not_to be_valid }
      end

      context 'loginが重複するとき' do
        before(:each) do
          FactoryGirl.create(:user)
          @user = FactoryGirl.build(:user)
        end

        it { expect(@user).not_to be_valid }
      end
    end

    describe 'password' do
      context 'nilが指定されたとき' do
        before(:each) { subject.password = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されたとき' do
        before(:each) { subject.password = '' }

        it { is_expected.not_to be_valid }
      end

      context '最小長が指定されたとき' do
        before(:each) { subject.password = 'a' * 4 }

        it { is_expected.to be_valid }
      end

      context '最小長より短い文字列が指定されたとき' do
        before(:each) { subject.password = 'a' * 3 }

        it { is_expected.not_to be_valid }
      end

      context '最大長が指定されたとき' do
        before(:each) { subject.password = 'a' * 16 }

        it { is_expected.to be_valid }
      end

      context '最大長より長い文字列が指定されたとき' do
        before(:each) { subject.password = 'a' * 17 }

        it { is_expected.not_to be_valid }
      end
    end
  end

  describe '利用者の検索について' do
    before(:each) do
      FactoryGirl.create(
        :user,
        name: 'テスト太郎',
        name_kana: 'テストタロウ',
        login: 'login',
        password: 'password'
      )

      FactoryGirl.create(
        :user,
        name: 'テスト次郎',
        name_kana: 'テストジロウ',
        login: 'login2',
        password: 'password2'
      )
    end

    context '何も指定しないとき' do
      it do
        expect do
          User.search_user(name: '', name_kana: '')
        end.not_to raise_error
      end

      it do
        expect(User.search_user(name: '', name_kana: '').count).to eq 2
      end
    end

    context '氏名が指定されているとき' do
      it do
        expect do
          User.search_user(name: 'テスト太郎')
        end.not_to raise_error
      end

      it do
        expect(User.search_user(name: 'テスト太郎').count).to eq 1
      end
    end

    context '氏名(カナ)が指定されているとき' do
      it do
        expect do
          User.search_user(name_kana: 'テストタロウ')
        end.not_to raise_error
      end

      it do
        expect(User.search_user(name_kana: 'テストタロウ').count).to eq 1
      end
    end
  end
end

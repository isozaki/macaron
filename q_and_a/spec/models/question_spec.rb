# == Schema Information
#
# Table name: questions
#
#  id                :integer          not null, primary key
#  title             :string(40)       not null
#  question          :text             not null
#  charge            :string(64)       not null
#  priority          :integer          not null
#  status            :integer          default(1), not null
#  limit_datetime    :datetime         not null
#  deleted           :integer          default(0), not null
#  created_user_name :string(64)       not null
#  updated_user_name :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'rails_helper'

describe Question, '検証について' do
  def valid_attributes
    {
      title: 'タイトル',
      question: '質問',
      charge: '担当者',
      priority: 2,
      status: 1,
      limit_datetime: 1.days.since,
      created_user_name: '質問者',
      updated_user_name: '質問者'
    }
  end

  before(:each) do
    @question = Question.new(valid_attributes)
  end

  subject { @question }

  describe '正しい値をセットするとき' do
    it { is_expected.to be_valid }
  end

  describe 'title' do
    context 'nilが指定されるとき' do
      before(:each) { subject.title = nil } 

      it { is_expected.not_to be_valid }
    end

    context 'ブランクが指定されるとき' do
      before(:each) { subject.title = '' }

      it { is_expected.not_to be_valid }
    end

    context '最大長が指定されたとき' do
      before(:each) { subject.title = 'あ' * 40 }

      it { is_expected.to be_valid }
    end

    context '最大長より長い文字が指定されたとき' do
      before(:each) { subject.title = 'あ' * 41 }

      it { is_expected.not_to be_valid }
    end

    context '「タイトル」が指定されるとき' do
      before(:each) { subject.title = 'タイトル' }

      it { is_expected.to be_valid }
    end
  end

  describe 'question' do
    context 'nilが指定されるとき' do
      before(:each) { subject.question = nil }

      it { is_expected.not_to be_valid }
    end

    context 'ブランクが指定されるとき' do
      before(:each) { subject.question = '' }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'charge' do
    context 'nilが指定されるとき' do
      before(:each) { subject.charge = nil }

      it { is_expected.not_to be_valid }
    end

    context 'ブランクが指定されるとき' do
      before(:each) { subject.charge = '' }

      it { is_expected.not_to be_valid }
    end

    context '最大長が指定されたとき' do
      before(:each) { subject.charge = 'あ' * 64 }

      it { is_expected.to be_valid }
    end

    context '最大長より長い文字が指定されたとき' do
      before(:each) { subject.charge = 'あ' * 65 }

      it { is_expected.not_to be_valid }
    end

    context '「担当者」が指定されるとき' do
      before(:each) { subject.charge = '担当者' }

      it { is_expected.to be_valid }
    end
  end

  describe 'priority' do
    context 'nilが指定されるとき' do
      before(:each) { subject.priority = nil }

      it { is_expected.not_to be_valid }
    end

    context 'ブランクが指定されるとき' do
      before(:each) { subject.priority = '' }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'status' do
    context 'nilが指定されるとき' do
      before(:each) { subject.status = nil }

      it { is_expected.not_to be_valid }
    end

    context 'ブランクが指定されるとき' do
      before(:each) { subject.status = '' }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'limit_datetime' do
    context 'nilが指定されるとき' do
      before(:each) { subject.limit_datetime = nil }

      it { is_expected.not_to be_valid }
    end

    context 'ブランクが指定されるとき' do
      before(:each) { subject.limit_datetime = '' }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'created_user_name' do
    context 'nilが指定されるとき' do
      before(:each) { subject.created_user_name = nil }

      it { is_expected.not_to be_valid }
    end

    context 'ブランクが指定されるとき' do
      before(:each) { subject.created_user_name = '' }

      it { is_expected.not_to be_valid }
    end

    context '最大長が指定されたとき' do
      before(:each) { subject.created_user_name = 'あ' * 64 }

      it { is_expected.to be_valid }
    end

    context '最大長より長い文字が指定されたとき' do
      before(:each) { subject.created_user_name = 'あ' * 65 }

      it { is_expected.not_to be_valid }
    end

    context '「質問者」が指定されるとき' do
      before(:each) { subject.created_user_name = '質問者' }

      it { is_expected.to be_valid }
    end
  end

  describe 'updated_user_name' do
    context '最大長が指定されたとき' do
      before(:each) { subject.updated_user_name = 'あ' * 64 }

      it { is_expected.to be_valid }
    end

    context '最大長より長い文字が指定されたとき' do
      before(:each) { subject.updated_user_name = 'あ' * 65 }

      it { is_expected.not_to be_valid }
    end

    context '「質問者」が指定されるとき' do
      before(:each) { subject.updated_user_name = '質問者' }

      it { is_expected.to be_valid }
    end
  end
end

describe Question, '質問を検索するとき' do
  before(:each) do
    FactoryGirl.create(
      :question,
      title: 'タイトル1',
      question: '質問内容1',
      charge: '担当者A',
      priority: 2,
      status: 1,
      limit_datetime: "2015-03-02 16:26:42",
      created_user_name: "質問者A"
    )

    FactoryGirl.create(
      :question,
      title: 'タイトル2',
      question: '質問内容2',
      charge: '担当者A',
      priority: 2,
      status: 2,
      limit_datetime: "2015-03-05 16:26:42",
      created_user_name: "質問者B"
    )
  end

  context 'タイトルが指定されているとき' do
    it do
      expect do
        Question.search_question(title: 'タイトル1')
      end.not_to raise_error
    end

    it do
      expect(Question.search_question(title: 'タイトル1').count).to eq 1
    end
  end

  context '担当者が指定されているとき' do
    it do
      expect do
        Question.search_question(charge: '担当者A')
      end.not_to raise_error
    end

    it do
      expect(Question.search_question(charge: '担当者A').count).to eq 2
    end
  end

  context 'ステータスが指定されているとき' do
    it do
      expect do
        Question.search_question(status: '1')
      end.not_to raise_error
    end

    it do
      expect(Question.search_question(status: '1').count).to eq 1
    end
  end

  context '回答期限が指定されているとき' do
    it do
      expect do
        Question.search_question(limit_datetime: '2015-03-04 00:00:00')
      end.not_to raise_error
    end

    it do
      expect(Question.search_question(limit_datetime: '2015-03-04 00:00:00').count).to eq 1
    end
  end
end

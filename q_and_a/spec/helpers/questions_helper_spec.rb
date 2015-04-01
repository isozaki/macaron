require 'rails_helper'

RSpec.describe QuestionsHelper, :type => :helper do
  describe 'priority_name' do
    context 'priorityが1のとき' do
      before(:each) do
        @question = mock_model(Question, priority: 1)
        @priority = @question.priority
      end

      it { expect(helper.priority_name(@priority)).to eq '低' }
    end

    context 'priorityが2のとき' do
      before(:each) do
        @question = mock_model(Question, priority: 2)
        @priority = @question.priority
      end

      it { expect(helper.priority_name(@priority)).to eq '中' }
    end

    context 'priorityが3のとき' do
      before(:each) do
        @question = mock_model(Question, priority: 3)
        @priority = @question.priority
      end

      it { expect(helper.priority_name(@priority)).to eq '高' }
    end
  end

  describe 'status_name' do
    context 'statusが1のとき' do
      before(:each) do
        @question = mock_model(Question, status: 1)
        @status = @question.status
      end

      it { expect(helper.status_name(@status)).to eq '回答待ち' }
    end

    context 'statusが2のとき' do
      before(:each) do
        @question = mock_model(Question, status: 2)
        @status = @question.status
      end

      it { expect(helper.status_name(@status)).to eq '回答済み' }
    end

    context 'statusが3のとき' do
      before(:each) do
        @question = mock_model(Question, status: 3)
        @status = @question.status
      end

      it { expect(helper.status_name(@status)).to eq '差し戻し' }
    end

    context 'statusが4のとき' do
      before(:each) do
        @question = mock_model(Question, status: 4)
        @status = @question.status
      end

      it { expect(helper.status_name(@status)).to eq '検討中' }
    end

    context 'statusが5のとき' do
      before(:each) do
        @question = mock_model(Question, status: 5)
        @status = @question.status
      end

      it { expect(helper.status_name(@status)).to eq '完了' }
    end

    context 'statusが6のとき' do
      before(:each) do
        @question = mock_model(Question, status: 6)
        @status = @question.status
      end

      it { expect(helper.status_name(@status)).to eq '却下' }
    end
  end

  describe 'priority_select_fromについて' do
    it { expect(helper.priority_select_from).to eq ([["低", 1], ["中", 2], ["高", 3]]) }
  end

  describe 'status_select_fromについて' do
    it { expect(helper.status_select_from).to eq ([
      ["回答待ち", 1],
      ["回答済み", 2],
      ["差し戻し", 3],
      ["検討中", 4],
      ["完了", 5],
      ["却下", 6]
    ]) }
  end
end

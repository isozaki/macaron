# == Schema Information
#
# Table name: answers
#
#  id                :integer          not null, primary key
#  question_id       :integer          not null
#  answer            :text             not null
#  deleted           :integer          default(0), not null
#  created_user_name :string(64)       not null
#  updated_user_name :string(64)       not null
#  created_at        :datetime
#  updated_at        :datetime
#

require 'rails_helper'

RSpec.describe Answer do
  describe '検証について' do
    def valid_attributes
      {
        question_id: 1,
        answer: '回答',
        created_user_name: '回答者',
        updated_user_name: '回答者'
      }
    end

    before(:each) do
      @answer = Answer.new(valid_attributes)
    end

    subject { @answer }

    describe 'question_id' do
      context 'nilが指定されるとき' do
        before(:each) { subject.question_id = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されるとき' do
        before(:each) { subject.question_id = '' }

        it { is_expected.not_to be_valid }
      end
    end

    describe 'answer' do
      context 'nilが指定されるとき' do
        before(:each) { subject.answer = nil }

        it { is_expected.not_to be_valid }
      end

      context 'ブランクが指定されるとき' do
        before(:each) { subject.answer = '' }

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
end

describe Answer, 'CSVの内容について' do
  it '正しいデータが生成されること' do
    @question = FactoryGirl.create(:question)
    @answer = FactoryGirl.create(:answer, question_id: @question.id)

    expect(@answer.generate_q_and_a_line).to eq(CSV.generate_line([
      @answer.question.id,
      @answer.question.title,
      @answer.question.question,
      @answer.question.charge,
      I18n.t("priority.#{Question::PRIORITY.key(@answer.question.priority)}"),
      I18n.t("status.#{Question::STATUS.key(@answer.question.status)}"),
      @answer.question.limit_datetime.strftime('%Y/%m/%d'),
      @answer.question.created_user_name,
      @answer.question.created_at.in_time_zone('Tokyo').strftime('%Y/%m/%d'),
      @answer.answer,
      @answer.created_user_name,
      @answer.created_at.in_time_zone('Tokyo').strftime('%Y/%m/%d')
    ], row_sep: "\r\n"))
  end
end

describe Answer, 'CSVダウンロード処理について' do
  before(:each) do
    @question = FactoryGirl.create(:question)
    @undownloaded = Answer.new(FactoryGirl.attributes_for(
      :answer,
      question_id: @question.id
    ))
    @undownloaded.save
    @downloaded = Answer.new(FactoryGirl.attributes_for(
      :answer,
      question_id: @question.id
    ))
    @downloaded.save

    @file_path = File.join(Rails.root, 'tmp', 'test', 'q_and_a', "#{Time.now.to_i.to_s}.csv")
  end

  after(:each) do
    # 不要なファイル削除
    FileUtils.rm_rf(File.dirname(@file_path)) if File.exist?(File.dirname(@file_path))
  end

  context 'ファイルの生成に成功するとき' do
    before(:each) do
      Answer.generate_q_and_a_file(@file_path)
    end

    it 'ファイルが存在すること' do
      expect(File.exist?(@file_path)).to be_truthy
    end
  end

  context 'ファイルの生成に失敗するとき' do
    before(:each) do
      expect(File).to receive(:open).with(@file_path, 'wb').and_raise 'エラー'
    end

    it 'ファイルが存在しないこと' do
      expect do
        Answer.generate_q_and_a_file(@file_path)
      end.to raise_error

      expect(File.exist?(@file_path)).to be_falsey
    end
  end
end

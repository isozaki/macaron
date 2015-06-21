# == Schema Information
#
# Table name: answers
#
#  id                :integer          not null, primary key
#  question_id       :integer          not null
#  answer            :text             not null
#  deleted           :integer          default(0), not null
#  created_user_name :string(64)       not null
#  updated_user_name :string(64)
#  created_at        :datetime
#  updated_at        :datetime
#

require 'csv'

class Answer < ActiveRecord::Base
  validates(:question_id, presence: true)
  validates(:answer, presence: true)
  validates(:created_user_name, presence: true, length: { maximum: 64 })
  validates(:updated_user_name, length: { maximum: 64 })

  has_one(:answer_attachment)
  belongs_to(:question)

  # 質問管理表ファイル生成処理
  def self.generate_q_and_a_file(file_path, matter_id)
    FileUtils.mkdir_p(File.dirname(file_path))

    File.open(file_path, 'wb') do |f|
      headers = %w(No. タイトル 質問内容 担当者 優先度 ステータス
        回答期限 質問者 質問日 回答内容 回答者 回答日)
      headers_line = CSV.generate_line(headers, row_sep: "\r\n")
      headers_line = headers_line.encode('Windows-31j', 'UTF-8') rescue raise('不正な文字が入力されました。')

      f.write(headers_line)

      matter = Matter.where(id: matter_id).first
      matter.questions.each do |question|
        question.answers.order('question_id ASC', 'id ASC').lock.all.each do |qa|
          csv_line = qa.generate_q_and_a_line
          csv_line = csv_line.encode('Windows-31j', 'UTF-8') rescue raise('不正な文字が入力されました。')
          f.write(csv_line)
        end
      end
    end
  end

  # 質問管理表生成処理
  def generate_q_and_a_line
    values = []
    values << question.id
    values << question.title
    values << question.question
    values << question.charge
    values << I18n.t("priority.#{Question::PRIORITY.key(question.priority)}")
    values << I18n.t("status.#{Question::STATUS.key(question.status)}")
    values << question.limit_datetime.strftime('%Y/%m/%d')
    values << question.created_user_name
    values << question.created_at.in_time_zone('Tokyo').strftime('%Y/%m/%d')
    values << answer
    values << created_user_name
    values << created_at.in_time_zone('Tokyo').strftime('%Y/%m/%d')

    CSV.generate_line(values, row_sep: "\r\n")
  end
end

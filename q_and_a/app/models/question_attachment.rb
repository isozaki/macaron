# == Schema Information
#
# Table name: question_attachments
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  filename    :string(255)      not null
#  filesize    :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class QuestionAttachment < ActiveRecord::Base
  validates(:question_id, presence: true)
  validates(:filename, presence: true, length: { maximum: 255 })
  validates(:filesize, presence: true)

  belongs_to(:question)

  after_destroy(:remove_file)

  # 添付ファイルの保存フォルダを作成
  def self.mkdir(dir_day = Date.current)
    path = File.join(
      Rails.root,
      'files',
      'question_attachments',
      dir_day.year.to_s,
      dir_day.month.to_s,
      dir_day.day.to_s
    )
    FileUtils.mkdir_p(path) unless FileTest.exists?(path)
    path
  end

  # 添付ファイルの保存場所を返す
  def file_path
    year  = created_at.year.to_s
    month = created_at.month.to_s
    day   = created_at.day.to_s
    File.join(Rails.root, 'files', 'question_attachments', year, month, day, id.to_s)
  end

  # 添付ファイルの登録処理
  def self.set_attachment(attachment_param, question)
    question_attachment = QuestionAttachment.new(
      question_id: question.id,
      filename: attachment_param.original_filename,
      filesize: attachment_param.size
    )
    if question_attachment.save
      File.open(File.join(mkdir, question_attachment.id.to_s), 'wb') do |of|
        of.write(attachment_param.read)
      end
    else
      fail CreateAttachmentError, question_attachment.errors.full_messages.first
    end
  end

  # 物理ファイルの削除処理
  def remove_file
    FileUtils.rm(file_path) if File.exists?(file_path)
  end
end

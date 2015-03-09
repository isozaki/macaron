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
end

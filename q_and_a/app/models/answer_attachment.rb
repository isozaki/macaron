# == Schema Information
#
# Table name: answer_attachments
#
#  id         :integer          not null, primary key
#  answer_id  :integer          not null
#  filename   :string(255)      not null
#  filesize   :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class AnswerAttachment < ActiveRecord::Base
  belongs_to(:answer)
end

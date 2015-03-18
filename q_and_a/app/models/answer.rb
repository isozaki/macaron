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

class Answer < ActiveRecord::Base
  validates(:question_id, presence: true)
  validates(:answer, presence: true)
  validates(:created_user_name, presence: true, length: { maximum: 64 })
  validates(:updated_user_name, length: { maximum: 64 })

  has_one(:answer_attachment)
  belongs_to(:questions)
end

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
  has_one(:answer_attachment)
  belongs_to(:questions)
end

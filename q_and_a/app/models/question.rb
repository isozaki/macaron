# == Schema Information
#
# Table name: questions
#
#  id                :integer          not null, primary key
#  title             :string(40)       not null
#  question          :text             not null
#  charge            :string(64)       not null
#  priority          :integer          not null
#  status            :integer          not null
#  limit_datetime    :datetime         not null
#  deleted           :integer          default(0), not null
#  created_user_name :string(64)       not null
#  updated_user_name :string(255)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

class Question < ActiveRecord::Base
  validates(:title, presence: true, length: { maximum: 40 })
  validates(:question, presence: true)
  validates(:charge, presence: true, length: { maximum: 64 })
  validates(:priority, presence: true)
  validates(:status, presence: true)
  validates(:limit_datetime, presence: true)
  validates(:created_user_name, presence: true, length: { maximum: 64 })
  validates(:updated_user_name, length: { maximum: 64 })

  has_many(:answers, -> { where(deleted: 0) })
  has_one(:question_attachment)
end

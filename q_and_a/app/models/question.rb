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

class Question < ActiveRecord::Base
  PRIORITY = {
    low: 1,
    mid: 2,
    high: 3,
  }

  STATUS = {
    unanswered: 1,
    answered: 2,
    remand: 3,
    review: 4,
    completion: 5,
    dismissal: 6
  }

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

  def self.search_question(params)
    questions = Question.order('id ASC')

    questions.where!('title LIKE ?', "%#{params[:title]}%") unless params[:title].blank?
    questions.where!('charge LIKE ?', "%#{params[:charge]}%") unless params[:charge].blank?
    questions.where!('status LIKE ?', "#{params[:status]}") unless params[:status].blank?
    questions.where!('limit_datetime <= ?', "#{params[:limit_datetime]}") unless params[:limit_datetime].blank?

    questions
  end
end

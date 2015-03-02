class Question < ActiveRecord::Base
  has_many(:answers, -> { where(deleted: 0) })
  has_one(:question_attachment)
end

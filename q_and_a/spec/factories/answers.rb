FactoryGirl.define do
  factory :answer do
    question_id 1
    answer "回答"
    deleted 0
    created_user_name "回答者"
    updated_user_name "回答者"
  end
end

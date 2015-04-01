FactoryGirl.define do
  factory :question do
    title "タイトル1"
    question "質問内容1"
    charge "担当者"
    priority 1
    status 1
    limit_datetime "2015-03-02 16:26:42"
    deleted 0
    created_user_name "質問者"
    updated_user_name "質問者"
  end
end

FactoryGirl.define do
  factory :user do
    name 'テスト太郎'
    name_kana 'テストタロウ'
    login 'login'
    password 'password'
    deleted 0
  end
end

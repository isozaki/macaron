# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user1 = FactoryGirl.create(:user,
                           name: 'テスト太郎',
                           name_kana: 'テストタロウ',
                           login: 'login',
                           password: 'password',
                           admin: 1
                          )

question1 = FactoryGirl.create(:question,
                               matter_id: 1,
                               title: 'テスト質問',
                               question: 'テスト質問内容',
                               charge: 'テスト次郎',
                               priority: 2,
                               status: 2,
                               limit_datetime: 10.days.since,
                               created_user_name: 'テスト太郎'
                              )

question2 = FactoryGirl.create(:question,
                               matter_id: 1,
                               title: '質問B',
                               question: '質問内容B',
                               charge: 'テスト太郎',
                               priority: 3,
                               status: 1,
                               limit_datetime: 5.days.since,
                               created_user_name: 'テスト次郎'
                              )

answer1 = FactoryGirl.create(:answer,
                             question_id: 1,
                             answer: 'テスト回答内容',
                             created_user_name: 'テスト次郎'
                            )

matter1 = FactoryGirl.create(:matter,
                             title: 'テスト案件A'
                            )

matter_user = FactoryGirl.create(:matter_user,
                                 matter_id: matter1.id,
                                 user_id: user1.id
                                )

class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id, null:false
      t.text :answer, null:false
      t.integer :deleted, null:false, default: 0
      t.string :created_user_name, null: false, limit: 64
      t.string :updated_user_name, null: false, limit: 64

      t.timestamps
    end
  end
end

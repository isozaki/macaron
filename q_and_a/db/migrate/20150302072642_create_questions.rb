class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title, null: false, limit: 40
      t.text :question, null: false
      t.string :charge, null: false, limit:64
      t.integer :priority, null: false
      t.integer :status, null: false
      t.datetime :limit_datetime, null: false
      t.integer :deleted, null: false, default: 0
      t.string :created_user_name, null: false, limit: 64
      t.string :updated_user_name, null: false, limite:64

      t.timestamps
    end
  end
end

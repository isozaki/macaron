class CreateMatterUsers < ActiveRecord::Migration
  def change
    create_table :matter_users do |t|
      t.integer :user_id, null: false
      t.integer :matter_id, null: false
      t.integer :deleted, null: false, default: 0

      t.timestamps
    end
  end
end

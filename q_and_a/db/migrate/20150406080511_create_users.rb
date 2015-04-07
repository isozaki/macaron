class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 64
      t.string :name_kana, null: false, limit: 64
      t.string :login, null: false, limit: 255
      t.string :password, null: false, limit: 16
      t.integer :deleted, null: false, default: 0

      t.timestamps
    end
  end
end

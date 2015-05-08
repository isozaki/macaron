class CreateMatters < ActiveRecord::Migration
  def change
    create_table :matters do |t|
      t.string :title, null: false, limit: 255
      t.integer :deleted, null: false, default: 0

      t.timestamps
    end
  end
end

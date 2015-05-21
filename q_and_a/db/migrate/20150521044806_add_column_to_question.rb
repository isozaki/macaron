class AddColumnToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :matter_id, :integer, null: false
  end
end

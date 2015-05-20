class ChangeColumnToUser < ActiveRecord::Migration
  def up
    change_column(:users, :admin, :boolean, null: false, default: false)
  end

  def down
    change_column(:users, :admin, :integer, null: false, default: 0)
  end
end

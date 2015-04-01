class CreateAnswerAttachments < ActiveRecord::Migration
  def change
    create_table :answer_attachments do |t|
      t.integer :answer_id, null: false
      t.string :filename, null: false, limit: 255
      t.integer :filesize, null: false, limit: 11

      t.timestamps
    end
  end
end

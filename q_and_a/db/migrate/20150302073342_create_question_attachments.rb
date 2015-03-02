class CreateQuestionAttachments < ActiveRecord::Migration
  def change
    create_table :question_attachments do |t|
      t.integer :question_id, null: false
      t.string :filename, null: false, limit: 255
      t.integer :filesize, null: false, limit: 11

      t.timestamps
    end
  end
end

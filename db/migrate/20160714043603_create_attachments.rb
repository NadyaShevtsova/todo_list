class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :comment, index: true, foreign_key: true
      t.string :file

      t.timestamps null: false
    end
  end
end

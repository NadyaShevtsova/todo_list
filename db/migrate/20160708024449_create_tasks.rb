class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :project, index: true, foreign_key: true
      t.string :name
      t.date :deadline
      t.boolean :mark_as_done, default: false
      t.integer :prioritize

      t.timestamps null: false
    end
  end
end

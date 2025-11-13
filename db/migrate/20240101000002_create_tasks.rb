class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :title, null: false
      t.text :description
      t.string :status, null: false
      t.date :due_date
      
      t.timestamps
    end
    
    add_index :tasks, :status unless index_exists?(:tasks, :status)
  end
end


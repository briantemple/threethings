class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.integer :status, :default => 0
      t.datetime :completed_at
      
      t.timestamps
    end
  end
end

class CreateProjectTasks < ActiveRecord::Migration
  def change
    create_table :project_tasks do |t|
      t.integer :task_id
      t.integer :project_id
      t.boolean :completed
      t.integer :clicks
      t.string :short_url

      t.timestamps
    end
  end
end

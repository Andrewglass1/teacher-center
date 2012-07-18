class AddCompletedOnToProjectTasks < ActiveRecord::Migration
  def change
    add_column :project_tasks, :completed_on, :date
  end
end

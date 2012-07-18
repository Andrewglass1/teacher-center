class GiveProjectTasksCompletedDefaultValue < ActiveRecord::Migration
  def change
    remove_column :project_tasks, :completed
    add_column :project_tasks, :completed, :boolean, :default => false
    remove_column :project_tasks, :clicks
    add_column :project_tasks, :clicks, :integer, :default => 0
    remove_column :projects, :on_track
  end
end

class AddDescriptionToProjectTasks < ActiveRecord::Migration
  def change
    add_column :project_tasks, :description, :string
  end
end

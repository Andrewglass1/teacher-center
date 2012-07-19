class RemoveTaskDescription < ActiveRecord::Migration
  def change
    remove_column :tasks, :description
  end
end

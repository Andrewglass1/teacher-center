class ChangeTypeToMedium < ActiveRecord::Migration
  def change
    rename_column :tasks, :type, :medium
  end
end

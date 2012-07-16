class AddStartDateToProject < ActiveRecord::Migration
  def change
    add_column :projects, :start_date, :date
  end
end

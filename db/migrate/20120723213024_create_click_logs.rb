class CreateClickLogs < ActiveRecord::Migration
  def change
    create_table :click_logs do |t|
      t.integer :project_id
      t.integer :daily_clicks
      t.integer :total_clicks_to_date
      t.date    :date
      t.timestamps
    end
  end
end

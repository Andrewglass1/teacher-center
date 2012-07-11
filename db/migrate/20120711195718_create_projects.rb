class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :dc_id
      t.string :dc_url
      t.integer :goal_cents
      t.integer :percent_funded
      t.integer :cost_to_complete_cents
      t.string :image_url
      t.string :teacher_name
      t.string :title
      t.string :school
      t.date :expiration_date
      t.string :fund_url
      t.string :city
      t.string :state
      t.string :description
      t.string :stage
      t.boolean :on_track

      t.timestamps
    end
  end
end

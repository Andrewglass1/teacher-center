class Project < ActiveRecord::Base
  attr_accessible :city, :cost_to_complete_cents, :dc_id, :dc_url, :description, :expiration_date, :fund_url, :goal_cents, :image_url, :on_track, :percent_funded, :school, :stage, :state, :teacher_name, :title
  has_many :tasks, :through => :project_tasks
end

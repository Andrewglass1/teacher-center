class ProjectTask < ActiveRecord::Base
  attr_accessible :clicks, :completed, :project_id, :short_url, :task_id
  belongs_to :project
  belongs_to :task
end

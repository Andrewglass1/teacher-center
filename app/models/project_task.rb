class ProjectTask < ActiveRecord::Base
  attr_accessible :clicks, :completed, :project_id, :short_url, :task_id
  belongs_to :project
  belongs_to :task
  after_create :get_short_link


  def complete
    update_attribute(:completed, true)
  end

  def get_short_link
    update_attribute(:short_url, UrlShortener.create_short_link(project.dc_url))
  end

  def update_clicks
    update_attribute(:clicks, UrlShortener.get_stats(short_url))
  end

end

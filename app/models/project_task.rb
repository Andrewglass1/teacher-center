class ProjectTask < ActiveRecord::Base
  attr_accessible :clicks, :completed, :project_id, :short_url, :task_id, :completed_on
  belongs_to :project
  belongs_to :task
  after_create :get_short_link


  def complete
    update_attributes({:completed => true, :completed_on => Date.today})
    Project.find(project_id).project_tasks.create(:task_id => task_id)
  end

  def get_short_link
    if task.medium == "PrintAndShare"
      update_attribute(:short_url, PdfGenerator.pdf_short_link(project.dc_id))
    else
      update_attribute(:short_url, UrlShortener.create_short_link(project.dc_url+"&id=#{id}"))
    end
  end

  def update_clicks
    update_attribute(:clicks, UrlShortener.get_stats(short_url))
  end

end

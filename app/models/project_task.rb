class ProjectTask < ActiveRecord::Base
  attr_accessible :clicks, :completed, :project_id, :short_url, :task_id
  belongs_to :project
  belongs_to :task
  after_create :create_short_link


  def create_short_link
    update_attribute(:short_url, bitly_client.shorten(project.dc_url).short_url)
  end

  private

  def bitly_client
    Bitly.use_api_version_3
    Bitly.new(ENV['bitly_username'], ENV['bitly_api_key'])
  end
end

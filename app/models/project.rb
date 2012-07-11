class Project < ActiveRecord::Base
  attr_accessible :city, :cost_to_complete_cents, :dc_id, :dc_url, :description,
    :expiration_date, :fund_url, :goal_cents, :image_url, :on_track,
    :percent_funded, :school, :stage, :state, :teacher_name, :title

  has_many :tasks, :through => :project_tasks

  def self.create_by_project_url(project_url)
    project_id = project_url.match(/\/(\d+)/)[1]
    Project.create(build_project(get_project(project_id)))
  end

  private

  def self.get_project(project_id)
    conn = Faraday.new(:url => DONORS_CHOOSE_BASE_URL)
    response = JSON.parse(conn.get("?id=#{project_id}&key=#{API_KEY}").body)
    response['proposals'].first
  end

  def self.build_project(response)
    {
      :city => response['city'],
      :cost_to_complete_cents => response['costToComplete'] * 100,
      :dc_id => response['id'],
      :dc_url => response['proposalURL'],
      :description => response['shortDescription'],
      :expiration_date => Date.parse(response['expirationDate']),
      :fund_url => response['fundURL'],
      :goal_cents => response['totalPrice'] * 100,
      :image_url => response['imageURL'],
      :on_track => true,
      :percent_funded => response['percentFunded'],
      :school => response['schoolName'],
      :stage => 'initial',
      :state => response['state'],
      :teacher_name => response['teacherName'],
      :title => response['title']
    }
  end

end

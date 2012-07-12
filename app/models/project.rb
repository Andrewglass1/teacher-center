class Project < ActiveRecord::Base
  attr_accessible :city, :cost_to_complete_cents, :dc_id, :dc_url, :description,
    :expiration_date, :fund_url, :goal_cents, :image_url, :on_track,
    :percent_funded, :school, :stage, :state, :teacher_name, :title

  has_many :tasks, :through => :project_tasks

  def self.create_by_project_url(project_url)
    project = DonorsChooseApi::Project.find_by_url(project_url)
    Project.create(build_project(project))
  end

  private

  def self.dollars_into_cents(dollars)
    (BigDecimal.new(dollars.to_s) * 100).to_i
  end

  def self.build_project(response)
    {
      :city => response.city,
      :cost_to_complete_cents => dollars_into_cents(response.cost_to_complete),
      :dc_id => response.donors_choose_id,
      :dc_url => response.proposal_url,
      :description => response.short_description,
      :expiration_date => Date.parse(response.expiration_date),
      :fund_url => response.fund_url,
      :goal_cents => dollars_into_cents(response.total_price),
      :image_url => response.image_url,
      :on_track => true,
      :percent_funded => response.percent_funded,
      :school => response.school_name,
      :stage => 'initial',
      :state => response.state,
      :teacher_name => response.teacher_name,
      :title => response.title
    }
  end

end

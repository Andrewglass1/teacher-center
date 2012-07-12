class Project < ActiveRecord::Base
  require 'open-uri'

  attr_accessible :city, :cost_to_complete_cents, :dc_id, :dc_url, :description,
    :expiration_date, :fund_url, :goal_cents, :image_url, :on_track,
    :percent_funded, :school, :stage, :state, :teacher_name, :title, :start_date

  has_many :tasks, :through => :project_tasks

  def self.create_by_project_url(project_url)
    if project_match = project_url.match(/(\d{5,6})/)
      project_id = project_match[1]
      if project = DonorsChooseApi::Project.find_by_id(project_id)
        Project.find_or_create_by_dc_id(build_project(project))
      end
    end
  end

  def projected_fund_date
    if Date.today < expiration_date
      Date.parse((start_date + projected_days_of_funding_needed).to_s)
    else
      expiration_date
    end
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
      :title => response.title,
      :start_date => get_start_date(response.proposal_url)
    }
  end

  def self.get_start_date(dc_url)
    page = Nokogiri::HTML(open(dc_url))
    Date.parse(
      page.css('.subtitle').text.strip().match(/([A-Z][a-z]{2}\s\d*,\s\d*)/)[1]
    )
  end

  def percentage_to_completion_date
    (Date.today - start_date)/length_of_project
  end

  def length_of_project
    expiration_date - start_date
  end

  def projected_days_of_funding_needed
    percentage_to_completion_date/(percent_funded.to_f/100) * length_of_project
  end

end

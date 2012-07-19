module ProjectApiWrapper
  require 'open-uri'

  class << self

    def extract_id(project_url)
      if match = project_url.match(/(\d{5,6})/)
        match[1].to_s
      end
    end

    def create_by_project_url(project_url)
      if project_info = find_by_id(extract_id(project_url))
        project = Project.find_or_create_by_dc_id(build_project(project_info))
        log_donations(project_info, project)
        project
      end
    end

    def update_information(project)
      project_info = find_by_id(project.dc_id)
      project.update_attributes({
        :cost_to_complete_cents => dollars_into_cents(project_info.cost_to_complete),
        :percent_funded => project_info.percent_funded
      })
      log_donations(project_info, project)
    end

    def log_donations(project_info, project)
      donation_log = project.donation_logs.find_or_create_by_date(Date.today)
      current_amount_funded = dollars_into_cents(project_info.total_price) - dollars_into_cents(project_info.cost_to_complete)
      donation_log.update_attribute(:amount_funded_cents, current_amount_funded)
    end

    def find_by_id(id)
      DonorsChooseApi::Project.find_by_id(id)
    end

    def build_project(response)
      {
        :city => html_decoder.decode(response.city),
        :cost_to_complete_cents => dollars_into_cents(response.cost_to_complete),
        :dc_id => response.donors_choose_id.to_s,
        :dc_url => response.proposal_url,
        :description => html_decoder.decode(response.short_description),
        :expiration_date => Date.parse(response.expiration_date),
        :fund_url => response.fund_url,
        :goal_cents => dollars_into_cents(response.total_price),
        :image_url => response.image_url,
        :percent_funded => response.percent_funded,
        :school => html_decoder.decode(response.school_name),
        :stage => 'initial',
        :state => html_decoder.decode(response.state),
        :teacher_name => html_decoder.decode(response.teacher_name),
        :title => html_decoder.decode(response.title),
        :start_date => get_start_date(response.proposal_url)
      }
    end

    def get_start_date(dc_url)
      Date.parse(
        open_page(dc_url).css('.subtitle').text.strip().match(/([A-Z][a-z]{2}\s\d*,\s\d*)/)[1]
      )
    end

    def open_page(dc_url)
      Nokogiri::HTML(open(dc_url))
    end

    def dollars_into_cents(dollars)
      (BigDecimal.new(dollars.to_s) * 100).to_i
    end

  private

    def html_decoder
      HTMLEntities.new
    end
  end
end

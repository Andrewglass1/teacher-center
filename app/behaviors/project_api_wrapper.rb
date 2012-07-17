module ProjectApiWrapper
  require 'open-uri'

  class << self

    def create_by_project_url(project_url)
      if project_match = project_url.match(/(\d{5,6})/)
        if project = find_by_id(project_match[1])
          Project.find_or_create_by_dc_id(build_project(project))
        end
      end
    end

    def update_information(project)
        project_info = find_by_id(project.id)
        project.update_attributes({
          :cost_to_complete_cents => dollars_into_cents(project_info.cost_to_complete),
          :percent_funded => project_info.percent_funded
        })
    end

    def find_by_id(id)
      DonorsChooseApi::Project.find_by_id(id)
    end

    def build_project(response)
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

  end
end
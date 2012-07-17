module ProjectBuilder

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

end
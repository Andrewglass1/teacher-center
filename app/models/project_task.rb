class ProjectTask < ActiveRecord::Base
  attr_accessible :clicks, :completed, :project_id, :short_url, :task_id,
    :completed_on, :description
  belongs_to :project
  belongs_to :task
  after_create :get_short_link


  def complete
    update_attributes({
      :completed => true,
      :completed_on => Date.today,
      :description => description
    })
    project.project_tasks.create(:task_id => task_id)
  end

  def get_short_link
    if task.medium == "PrintAndShare"
      update_for_print_and_share
    else
      update_attribute(
        :short_url, UrlShortener.create_short_link(project.dc_url+"&id=#{id}"))
    end
  end

  def update_for_print_and_share
    Thread.new do
      self.short_url = PdfGenerator.pdf_short_link(project.dc_id)
      self.save
    end
  end

  def update_clicks
    update_attribute(:clicks, UrlShortener.get_stats(short_url))
  end

  def description
    if completed
      read_attribute(:description)
    elsif project.near_end?
      "My donors choose project is almost ending, help us raise the last " +
        "$#{project.dollars_needed}"
    elsif project.off_track?
      "I need your help to fully fund my project on donorschoose.org, the " +
        "kids will appreciate your support!"
    else
      "Check out my project on donorschoose.org."
    end
  end

  def letter_copy
    opening_copy + "\n #{project.description}".gsub(/^ +/, '') +
    if project.off_track?
      off_track_copy
    else
      on_track_copy
    end
  end

  def opening_copy
    <<-END.gsub(/^ {6}/, '')
      I'm writing to you seeking your support for you to help me make my classroom a better place.
      I'm using a tool called DonorsChoose.org to accomplish this goal.
      DonorsChoose is a website that allows teachers like myself to request funding to do amazing things such as, take my students on field trips,
      buy new more relative books for the classroom, and so much more!

      My Specific Project is about:
    END
  end

  def off_track_copy
    <<-END.gsub(/^ {6}/, '')
      The goal for my project is to raise $#{project.goal_dollars} however i still need $#{project.dollars_needed}.
      To donate please visit my page at #{short_url}
    END
  end

  def on_track_copy
    <<-END.gsub(/^ {6}/, '')
      I'm currently behind my goal of raising $#{project.goal_dollars} and still need $#{project.dollars_needed}.
      To donate please visit my page at #{short_url}
    END
  end


end

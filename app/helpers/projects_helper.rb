module ProjectsHelper

  def status_image(project)
    if project.off_track? == false || project.completed?
      "checkmark.png"
    else
      "warning.png"
    end 
  end

  def status_text(project)
    if project.completed?
      "Project Fully Funded"
    elsif project.off_track? || project.off_track? ==nil
      "Off Track to Fund"
    else
      "On Track to Fund"
    end
  end
    
  def days_left(project)
    if project.days_to_end > 0
      "#{project.days_to_end}<br />Days Left".html_safe
    else
      "Project has been completed"
    end
  end

  def project_expiration_date(project)
    if project.days_to_end > 0
      project.expiration_date.strftime("Expires on %B %d")
    else
      ""
    end
  end
  
  def display_fund_date(project)
    project.projected_fund_date.strftime("Projected to be Funded on: %n %B %d, %Y")
  end
end

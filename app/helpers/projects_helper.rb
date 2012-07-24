module ProjectsHelper

  def status_image(project)
    unless !project.off_track? 
      "checkmark.png"
    else
      "warning.png"
    end 
  end

  def status_text(project)
    unless !project.off_track? 
      "On Track to Fund"
    else
      "Off Track to Fund"
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
end

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
end

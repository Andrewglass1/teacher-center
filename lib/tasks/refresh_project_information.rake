desc "Refreshes information that may update on projects"

task :refresh_project_information do
  Project.each do |project|
    project.update_information
  end

end

desc "Refreshes information that may update on projects"

task :refresh_project_information => :environment do
  Project.all.each do |project|
    project.update_information
  end

end

desc "Refreshes information that may update on projects"

task :refresh_project_information => :environment do
  Project.all.each do |project|
    if project.dc_id.match(/(\d{5,6})/)
      project.update_information
    end
  end

end

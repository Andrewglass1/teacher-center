desc "Refreshes click statistics on a project task"

task :refresh_project_task_clicks => :environment do
  ProjectTask.all.each do |project_task|
    if project_task.short_url
      project_task.update_clicks
    end
  end
  Project.all.each do |project|
    if project.dc_id.match(/(\d{5,6})/)
      project.log_project_clicks
    end
  end

end

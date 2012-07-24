class PagesController < ApplicationController
  before_filter :create_project_if_session, :redirect_to_project

  def welcome

  end

private

  def create_project_if_session
    if project_url.present? && current_user
      if project.user_id
        redirect_to root_path, notice: "Someone else already has that project"
      else
        cookies[:project_url] = nil
        project.update_attributes(user_id: current_user.id)
        redirect_to project_path(project),
          notice: "Project created successfully"
      end
    end
  end

  def redirect_to_project
    last_project = current_user.projects.last
    if current_user && project_url.empty? && !last_project.completed?
      redirect_to project_path(current_user.projects.last)
    end
  end

  def project_url
    cookies[:project_url] || ""
  end

  def project
    @project ||= Project.find_by_dc_id(ProjectApiWrapper.id_for(project_url))
  end

end

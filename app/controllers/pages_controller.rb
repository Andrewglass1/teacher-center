class PagesController < ApplicationController
  before_filter :create_project_if_session, :redirect_to_project

  def welcome
  end

  private

  def create_project_if_session
    if user_with_project_url && project.user_id
      redirect_to root_path, notice: "Someone else already has that project"
    elsif user_with_project_url
      create_project
    end
  end

  def user_with_project_url
    project_url.present? && current_user
  end

  def create_project
    cookies.delete :project_url
    project.update_attributes(user_id: current_user.id)
    redirect_to project_path(project),
      notice: "Project created successfully"
  end

  def redirect_to_project
    if current_user && project_url.empty? && last_project && !last_project.completed?
      redirect_to project_path(last_project)
    end
  end

  def project_url
    cookies[:project_url].to_s
  end

  def last_project
    @last_project ||= current_user.projects.last
  end

  def project
    @project ||= Project.find_by_dc_id(ProjectApiWrapper.id_for(project_url))
  end
end

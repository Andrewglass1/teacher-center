class PagesController < ApplicationController
  before_filter :create_project_if_session

  def welcome

  end

private

  def project_url
    cookies[:project_url]
  end

  def create_project_if_session
    if project_url && current_user
      dc_id = ProjectApiWrapper.extract_id(project_url)
      project = Project.find_by_dc_id(dc_id)
      if project.user_id
        redirect_to root_path, notice: "Someone else already has that project"
      else
        cookies.delete(:project_url)
        project.update_attributes(user_id: current_user.id)
        redirect_to project_path(project), notice: "Project created successfully"
      end
    end
  end

end

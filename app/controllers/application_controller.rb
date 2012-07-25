class ApplicationController < ActionController::Base
  protect_from_forgery

  def after_sign_in_path_for(user)
    if just_signed_in_and_have_project
      project_path(current_user.projects.last)
    elsif just_signed_in_or_up
      super
    else
      request.referer || stored_location_for(user) || root_path
    end
  end

  private

  def just_signed_in_and_have_project
    (request.referer == sign_in_url) && current_user.projects.any?
  end

  def just_signed_in_or_up
    (request.referer == sign_in_url) || (request.referer == sign_up_url)
  end

  def sign_in_url
    url_for(
      :action => 'new',
      :controller => 'sessions',
      :only_path => false,
      :protocol => 'http'
    )
  end

  def sign_up_url
    url_for(
      :action => 'new',
      :controller => 'registrations',
      :only_path => false,
      :protocol => 'http'
    )
  end
end

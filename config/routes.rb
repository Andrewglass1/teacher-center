Teachercenter::Application.routes.draw do
  devise_for :users

  resources :projects
  resources :project_tasks
  root :to => "pages#welcome"
end

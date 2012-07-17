Teachercenter::Application.routes.draw do
  resources :projects
  resources :project_tasks
  root :to => "pages#welcome"
end

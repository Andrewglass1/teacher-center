Teachercenter::Application.routes.draw do
  resources :projects 
  root :to => "pages#welcome"
end
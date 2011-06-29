Dummy::Application.routes.draw do
  devise_for :users
  root :to => "home#index"

  match "/miracle" => "home#miracle"
end

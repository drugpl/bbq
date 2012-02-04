Dummy::Application.routes.draw do
  devise_for :users
  root :to => "home#index"

  match "/miracle" => "home#miracle"
  match "/ponycorns" => "home#ponycorns"
  match "/rainbow" => "home#rainbow"
end

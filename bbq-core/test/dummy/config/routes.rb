Dummy::Application.routes.draw do
  devise_for :users
  root :to => "home#index"

  get "/miracle" => "home#miracle"
  get "/ponycorns" => "home#ponycorns"
  get "/rainbow" => "home#rainbow"
  get "/uh_oh" => "home#uh_oh"
end

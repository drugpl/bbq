Dummy::Application.routes.draw do
  root :to => "home#index"

  match "/miracle" => "home#miracle"
  match "/ponycorns" => "home#ponycorns"
  match "/rainbow" => "home#rainbow"
end

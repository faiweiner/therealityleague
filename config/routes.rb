Rails.application.routes.draw do
  resources :shows

  resources :leagues

  resources :users

	root :to => 'pages#home'

	resources :users
end

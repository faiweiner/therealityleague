Rails.application.routes.draw do
	root :to => 'pages#home'
	
	resources :shows
	resources :leagues
	resources :users

	get '/' => 'sessions#new'
	post '/login' => 'sessions#login_attempt'
	delete '/login' => 'sessions#logout'
end

Rails.application.routes.draw do
	root :to => 'pages#home'

	get 'shows/search' => 'shows#search'
	resources :shows

	get 'leagues/search' => 'leagues#search'
	post 'leagues/search/:search' => 'leagues#results'
	resources :leagues
	resources :users

	get '/login' => 'sessions#new'
	post '/login' => 'sessions#login_attempt'
	delete '/login' => 'sessions#logout'
end

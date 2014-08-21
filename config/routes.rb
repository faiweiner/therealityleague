Rails.application.routes.draw do
  resources :scores

	root :to => 'pages#home'

	get 'shows/search' => 'shows#search'
	resources :shows

	get 'leagues/search' => 'leagues#search'
	post 'leagues/search/:search' => 'leagues#results'
	post 'leagues/access' => 'leagues#access', :as => :league_access 
	post 'leagues/join/:league' => 'leagues#join', :as => :league_join
	resources :leagues
	resources :users

	post 'rosters/:roster_id/:contestant_id' => 'rosters#add', :as => :roster_add
	resources :rosters

	resources :contestants

	get '/login' => 'sessions#new'
	post '/login' => 'sessions#login_attempt'
	delete '/login' => 'sessions#logout'
end

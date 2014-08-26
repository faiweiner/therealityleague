Rails.application.routes.draw do
	root :to => 'pages#home'

  resources :scores

	get 'pages/about' => 'pages#about'
	get 'shows/search' => 'shows#search'
	resources :shows




	get 'leagues/search' => 'leagues#search'
	post 'leagues/search/:search' => 'leagues#results'
	resources :leagues
	get 'leagues/invite/:invite' => 'leagues#invite', :as => :league_invite
	post 'leagues/access' => 'leagues#access', :as => :league_access 
	post 'leagues/join/:league' => 'leagues#join', :as => :league_join

	resources :users

	post 'rosters/:roster_id/add/:contestant_id' => 'rosters#add', :as => :roster_add
	post 'rosters/:roster_id/remove/:contestant_id' => 'rosters#remove', :as => :roster_remove
	resources :rosters

	get 'contestants/show/:show_id' => 'contestants#index', :as => :contestants_show
	get 'contestants' => 'contestants#all'
	post 'contestants' => 'contestants#create'
	get 'contestants/:contestant_id/edit' => 'contestants#edit_single' , :as => :edit_contestant
	get 'contestants/new/:show_id' => 'contestants#new', :as => :new_contestant
	get 'contestants/:id' => 'contestants#show', :as => :contestant
	patch 'contestants/:id' => 'contestants#update'
	delete 'contestants/:id' => 'contestants#destroy'

	get '/login' => 'sessions#new'
	post '/login' => 'sessions#login_attempt'
	delete '/login' => 'sessions#logout'
end

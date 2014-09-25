Rails.application.routes.draw do
	root :to => 'pages#home'

	get 'events/:show_id' => 'events#display', :as => :event
  resources :events
  get 'points/display'
  get 'points/get_seasons' => 'points#seasons', :as => :get_seasons
  resources :points
  
	get 'pages/about' => 'pages#about'

	get 'seasons/search' => 'seasons#search'
	get 'seasons' => 'seasons#index', :as => :seasons
	post 'seasons' => 'seasons#create'
	get 'seasons/new' => 'seasons#new', :as => :new_season
	get 'seasons/:id/edit' => 'seasons#edit', :as => :edit_season
	patch 'seasons/:id/publish' => 'seasons#publish', :as => :publish_season
	patch 'seasons/:id/unpublish' => 'seasons#unpublish', :as => :unpublish_season
	get 'seasons/:id' => 'seasons#display', :as => :season
	patch 'seasons/:id' => 'seasons#update'
	put 'seasons/:id' => 'seasons#update'
	delete 'seasons/:id' => 'seasons#destroy'
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

	get 'contestants/season/:season_id' => 'contestants#index', :as => :contestants_season
	post 'contestants' => 'contestants#create'
	get 'contestants/new/:season_id' => 'contestants#new', :as => :new_contestant
	get 'contestants/:id' => 'contestants#display', :as => :contestant
	post 'contestants/:id' => 'contestants#update'
	delete 'contestants/:id' => 'contestants#destroy'

	get '/login' => 'sessions#new'
	post '/login' => 'sessions#login_attempt'
	delete '/login' => 'sessions#logout'

	get 'admin' => 'admin#home'
end

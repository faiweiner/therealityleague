Rails.application.routes.draw do
	root :to => 'pages#home'

	get 'schemes/:show_id' => 'schemes#display', :as => :event
	resources :schemes
	
	get 'events/display'
	get 'events/get_seasons' => 'events#seasons', :as => :get_seasons
	resources :events
	
	get 'episodes' => 'episodes#index', :as => :episodes
	post 'episodes' => 'episodes#create'
	get 'episodes/new' => 'episodes#new', :as => :new_episode
	get 'episodes/:id' => 'episodes#display', :as => :episode

	get 'pages/about' => 'pages#about'

	get 'shows/new' => 'shows#new', :as => :new_show
	get 'shows/:id' => 'shows#display', :as => :show
	resources :shows


	get 'seasons/search' => 'seasons#search'
	get 'seasons' => 'seasons#index', :as => :seasons
	post 'seasons' => 'seasons#create'
	get 'seasons/new/:show_id' => 'seasons#new', :as => :new_season_show
	get 'seasons/new' => 'seasons#new', :as => :new_season
	get 'seasons/:id/edit' => 'seasons#edit', :as => :edit_season
	patch 'seasons/:id/publish' => 'seasons#publish', :as => :publish_season
	patch 'seasons/:id/unpublish' => 'seasons#unpublish', :as => :unpublish_season
	get 'seasons/:id' => 'seasons#display', :as => :season
	patch 'seasons/:id' => 'seasons#update'
	put 'seasons/:id' => 'seasons#update'
	delete 'seasons/:id' => 'seasons#destroy'


	get 'leagues/search' => 'leagues#search'
	get 'leagues/:id/invite' => 'leagues#invite', :as => :league_invite
	get 'leagues/:id' => 'leagues#display', :as => :league
	resources :leagues
	resources :fantasies, path: 'leagues', :controller => 'leagues'
	post 'leagues/access' => 'leagues#access', :as => :league_access

	resources :users
	
	post 'rosters/:roster_id/add/:contestant_id' => 'rosters#add', :as => :roster_add
	post 'rosters/:roster_id/remove/:contestant_id' => 'rosters#remove', :as => :roster_remove
	post 'rosters/:league_id' => 'rosters#create', :as => :rosters
	resources :rosters

	get 'contestants/season/:season_id' => 'contestants#index', :as => :contestants_season
	post 'contestants' => 'contestants#create'
	get 'contestants/new/:season_id' => 'contestants#new', :as => :new_contestant
	get 'contestants/:id' => 'contestants#display', :as => :contestant
	post 'contestants/:id' => 'contestants#update'
	delete 'contestants/:id' => 'contestants#destroy'

	get 'login' => 'sessions#new'
	post 'login' => 'sessions#login_attempt'
	delete 'login' => 'sessions#logout'

	get 'admin' => 'admin#home'
	get 'admin/shows' => 'admin#shows', :as => :admin_shows

	get 'api/shows' => 'application#shows_list', :as => :api_shows
	get 'api/seasons' => 'application#seasons_list', :as => :api_seasons
end

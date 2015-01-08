Rails.application.routes.draw do
	root :to => 'pages#home'

	get		'schemes/:show_id' => 'schemes#display', :as => :event
	resources :schemes
	
	get		'events/display'
	get		'events/get_seasons' => 'events#seasons', :as => :get_seasons
	resources :events
	
	get		'episodes' => 'episodes#index', :as => :episodes
	post	'episodes' => 'episodes#create'
	get		'episodes/new' => 'episodes#new', :as => :new_episode
	get		'episodes/new/:season_id' => 'episodes#new'
	get		'episodes/:id' => 'episodes#display', :as => :episode

	get		'pages/about' => 'pages#about'

	get		'shows/new' => 'shows#new', :as => :new_show
	get		'shows/:id' => 'shows#display', :as => :show
	resources :shows


	get		'seasons/search' => 'seasons#search'
	get		'seasons' => 'seasons#index', :as => :seasons
	post	'seasons' => 'seasons#create'
	get		'seasons/new/:show_id' => 'seasons#new', :as => :new_season_show
	get		'seasons/new' => 'seasons#new', :as => :new_season
	get		'seasons/:id/edit' => 'seasons#edit', :as => :edit_season
	patch 'seasons/:id/publish' => 'seasons#publish', :as => :publish_season
	patch 'seasons/:id/unpublish' => 'seasons#unpublish', :as => :unpublish_season
	get		'seasons/:id' => 'seasons#display', :as => :season
	patch 'seasons/:id' => 'seasons#update'
	put		'seasons/:id' => 'seasons#update'
	delete 'seasons/:id' => 'seasons#destroy'

	get		'leagues/new' => 'leagues#new', :as => :new_league
	get		'leagues' => 'leagues#index', :as => :leagues
	get		'leagues/search' => 'leagues#search'
	get		'leagues/:id/invite' => 'leagues#invite', :as => :league_invite
	get		'leagues/:id' => 'leagues#display', :as => :league
	resources :leagues
	resources :fantasies, path: 'leagues', :controller => 'leagues'
	post		'leagues/access' => 'leagues#access', :as => :league_access

	resources :users
	resources :messages
	
	post	'rosters/:roster_id/add/:contestant_id' => 'rosters#add', :as => :roster_add
	post	'rosters/:roster_id/remove/:contestant_id' => 'rosters#remove', :as => :roster_remove
	get		'rosters/:roster_id/current' => 'rosters#current', :as => :roster_current
	post	'rosters/:league_id' => 'rosters#create', :as => :rosters
	get		'rosters' => 'rosters#index'
	get		'rosters/new' => 'rosters#new', :as => :new_roster
	get		'rosters/:id/edit' => 'rosters#edit', :as => :edit_roster
	get		'rosters/:id' => 'rosters#display', :as => :roster
	patch 'rosters/:id' => 'rosters#update'
	put		'rosters/:id' => 'rosters#update'
	delete 'rosters/:id' => 'rosters#destroy'

	get		'rounds/:league_id/edit' => 'rounds#edit', :as => :rounds_edit
	post	'rounds/:league_id' => 'rounds#create', :as => :rounds_create
	get		'rounds/:league_id/:user_id' => 'rounds#index', :as => :rounds
	get		'rounds/:round_id' => 'rounds#display', :as => :round_display
	get		'rounds/edit/:round_id' => 'rounds#singleedit', :as => :round_edit
	post	'rounds/:round_id/add/:contestant_id' => 'rounds#add', :as => :round_add
	post	'rounds/:round_id/remove/:contestant_id' => 'rounds#remove', :as => :round_remove
	get		'rounds/round/:round_id/save' => 'rounds#save', :as => :round_save
	resources :rounds
	
	get		'contestants/season/:season_id' => 'contestants#index', :as => :contestants_season
	post	'contestants' => 'contestants#create'
	get		'contestants/new/:season_id' => 'contestants#new', :as => :new_contestant
	get		'contestants/:id' => 'contestants#display', :as => :contestant
	post	'contestants/:id' => 'contestants#update'
	delete 'contestants/:id' => 'contestants#destroy'

	get		'login' => 'sessions#new'
	post		'login' => 'sessions#login_attempt'
	delete 'login' => 'sessions#logout'

	get		'admin' => 'admin#home'

	# all shows and all seasons lists
	get		'admin/shows' => 'admin#shows', :as => :admin_shows
	get		'admin/seasons' => 'admin#seasons', :as => :admin_seasons

	# API for pulling lists via AJAX
	get		'api/shows'				=> 'application#shows_list',			:as => :api_shows
	get		'api/seasons'			=> 'application#seasons_list',		:as => :api_seasons
	get		'api/episodes'			=> 'application#episodes_list', :as => :api_episodes
	get		'api/contestants'	=> 'application#contestants_list', :as => :api_contestants
	get		'api/schemes'			=> 'application#schemes_list',		:as => :api_schemes	
end

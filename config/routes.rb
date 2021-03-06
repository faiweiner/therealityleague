Rails.application.routes.draw do
	root :to => 'pages#home'

	resources :messages

	get		'events/display/:season_id/:episode_id' => 'events#display', :as => :display_events
	get		'events/get_seasons' => 'events#seasons', :as => :get_seasons
	delete 'events/:event_id' => 'events#destroy', :as => :delete_event
	resources :events
	
	get		'episodes' => 'episodes#index', :as => :episodes
	post	'episodes' => 'episodes#create'
	get		'episodes/new' => 'episodes#new', :as => :new_episode
	get		'episodes/new/:season_id' => 'episodes#new'
	get		'episodes/:id' => 'episodes#display', :as => :episode

	get		'pages/about' => 'pages#about'

	get		'statuses/' => 'statuses#index', :as => :statuses
	get		'statuses/:season_id' => 'statuses#display', :as => :statuses_display

	post 	'schemes/:id/assign' => 'schemes#assign'
	get		'schemes/' => 'schemes#index', as: 'schemes'
	get 	'schemes/fetch_schemes' => 'schemes#filter', as: 'fetch_schemes'
	resources :schemes

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

	get		'shows/new' => 'shows#new', :as => :new_show
	get		'shows/:id' => 'shows#display', :as => :show
	resources :shows

	get		'leagues/new' => 'leagues#new', :as => :new_league
	get		'leagues' => 'leagues#index', :as => :leagues
	get		'leagues/search' => 'leagues#search'
	get		'leagues/:id/invite' => 'leagues#invite', :as => :league_invite
	get		'leagues/:id' => 'leagues#display', :as => :league
	get		'leagues/:id/schemes' => 'leagues#manage_schemes', :as => :league_schemes
	post	'leagues/:id/schemes/:scheme_id' => 'leagues#scheme_action', :as => :league_scheme_action
	resources :leagues
	resources :fantasies, path: 'leagues', :controller => 'leagues'
	post		'leagues/access' => 'leagues#access', :as => :league_access

	post	'users/signup_fb' => 'users#fb_create', :as => :fb_create	
	post	'users/:id/link_fb' => 'users#link_fb', :as => :link_fb
	post	'users/:id/unlink_fb' => 'users#unlink_fb', :as => :unlink_fb
	resources :users
	resources :messages
	
	post	'rosters/:roster_id/add/:contestant_id' => 'rosters#add', :as => :roster_add
	post	'rosters/:roster_id/remove/:contestant_id' => 'rosters#remove', :as => :roster_remove
	get		'rosters/:roster_id/current' => 'rosters#current', :as => :roster_current
	post	'rosters/:league_id' => 'rosters#create', :as => :rosters
	get		'rosters' => 'rosters#index'
	get		'rosters/new' => 'rosters#new', :as => :new_roster
	get		'rosters/:roster_id/edit' => 'rosters#edit', :as => :roster_edit
	get		'rosters/:id' => 'rosters#display', :as => :roster
	patch 'rosters/:id' => 'rosters#update'
	put		'rosters/:id' => 'rosters#update'
	delete 'rosters/:id' => 'rosters#destroy'

	post	'rounds/:league_id' => 'rounds#create', :as => :rounds_create
	get		'rounds/:league_id/:user_id' => 'rounds#index', :as => :rounds
	get		'rounds/:round_id' => 'rounds#display', :as => :round_display
	get		'rounds/:round_id/edit' => 'rounds#edit', :as => :round_edit
	post	'rounds/:round_id/add/:contestant_id' => 'rounds#add', :as => :round_add
	post	'rounds/:round_id/bulk' => 'rounds#bulk_add', :as => :round_bulk_add
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
	post	'login' => 'sessions#login_attempt'
	post	'login/fb' => 'sessions#facebook_login', :as => :facebook_login
	delete 'login' => 'sessions#logout'

	get		'admin' => 'admin#home'

	# all shows and all seasons lists
	get		'admin/shows' => 'admin#shows', :as => :admin_shows
	get		'admin/seasons' => 'admin#seasons', :as => :admin_seasons

	# API for pulling lists via AJAX
	get		'api/shows'				=> 'application#shows_list',			:as => :api_shows
	get		'api/seasons'			=> 'application#seasons_list',		:as => :api_seasons
	get		'api/episodes'		=> 'application#episodes_list', 	:as => :api_episodes
	get		'api/contestants'	=> 'application#contestants_list', :as => :api_contestants
	get		'api/schemes' 		=> 'application#schemes_list', 		:as => :api_schemes
end

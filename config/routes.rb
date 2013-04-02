Phl::Application.routes.draw do
  devise_for :players

  resources :trades

  get '/attend/:game'     => 'games#attend',     as: 'attend_game'
  get '/attendance/:game' => 'games#attendance', as: 'game_attendance'

  get '/team/:slug'       => 'teams#team_page',  as: 'team_page'

  get '/profile/:name'    => 'players#profile',  as: 'player_profile'

  root to: 'players#index'
end

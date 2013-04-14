Phl::Application.routes.draw do
  devise_for :players

  resources :trades
  resources :goals

  get '/attend/:game'        => 'games#attend',       as: 'attend_game'
  get '/attendance/:game'    => 'games#attendance',   as: 'game_attendance'

  get '/team/:team'          => 'teams#show',         as: 'team_page'

  get '/profile/:name'       => 'players#profile',    as: 'player_profile'

  get '/boxes/:id/edit'      => 'players#edit_box',   as: 'edit_box'
  delete '/boxes/:id/delete' => 'players#delete_box', as: 'delete_box'

  get '/games/:id'           => 'games#show'

  scope '/games/:id' do
    get '/substitutions' => 'games#substitutions'
    resource :report, path_names: { new: 'make' }
    put '/substitute' => 'games#substitute'
  end

  root to: 'players#index'
end

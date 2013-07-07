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
    get '/report/make/:half' => 'reports#new', as: 'new_report'
    resource :report, only: [:create, :destroy]
    get '/substitutions/:half'  => 'games#substitutions_by_half'
    post '/substitute'          => 'games#substitute'
    post '/substitution'        => 'games#update_substitution'
    post '/substitution/delete' => 'games#delete_substitution'
    put '/finalize'             => 'games#finalize'
  end

  root to: 'players#index'
end

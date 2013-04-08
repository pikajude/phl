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

  scope '/games/:id' do
    resource :report, path_names: { new: 'make' }
    put '/report/goal' => 'reports#goal', as: 'add_goal_to_report'
    put '/report/sub'  => 'reports#substitute', as: 'add_substitute_to_report'
  end

  root to: 'players#index'
end

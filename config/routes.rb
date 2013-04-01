Phl::Application.routes.draw do
  devise_for :players

  resources :trades

  get '/attend/:game'     => 'games#attend',     as: 'attend_game'
  get '/attendance/:game' => 'games#attendance', as: 'game_attendance'

  root to: 'players#index'
end

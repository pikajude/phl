Phl::Application.routes.draw do
  devise_for :players

  resources :trades

  get '/attend/:game' => 'games#attend', as: 'attend_game'

  root to: 'players#index'
end

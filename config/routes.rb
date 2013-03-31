Phl::Application.routes.draw do
  devise_for :players

  resources :trades

  root to: 'boards#index'
end

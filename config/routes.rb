Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "/", to: "homepage#index", as: :homepage

  namespace :authentication, path: '', as: '' do
    resources :users, only: [:new,:create]
    resources :sessions, only: [:new, :create]
  end
  # Defines the root path route ("/")
  # root "posts#index"
  get "game_deck", to: "games#deck", as: :game_deck
  post 'initialize_monster', to: 'games#initialize_monster', as: :initialize_monster
  get "game_hand", to: "games#hand", as: :game_hand
  get "game_board/:mon1/:mon2", to: "games#board", as: :game_board
end

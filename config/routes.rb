Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'api/players', to: 'players#create'
  post 'api/games', to: 'game#create'
  post 'api/games/:game_id/play', to: 'game#play'
end

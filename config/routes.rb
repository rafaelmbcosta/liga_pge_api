Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'

  namespace :api do
    namespace :v1 do
      resources :scores
      resources :battles
      resources :dispute_months
      resources :rounds
      resources :teams
      resources :players
      resources :seasons
      resources :currencies
      resources :awards
      resources :month_activities
      get 'league' => 'dispute_months#league_points'
      get 'partials' => 'rounds#partials'
      get 'partials/:id' => 'rounds#partial'
      get 'season_score' => 'seasons#scores'
      get 'search_player/:name' => 'players#search_player'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end


Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'

  namespace :api do
    namespace :v1 do
      resources :scores
      resources :battles
      resources :dispute_months
      resources :round
      resources :teams do
        collection do
          post 'activation'
          get 'find_team'
        end
      end
      resources :seasons
      resources :awards
      resources :month_activities
      resources :flow_control
      get 'closed_market_routines' => 'rounds#closed_market_routines'
      get 'championship' => 'awards#championship'
      get 'currencies/rerun' => 'currencies#rerun'
      get 'round_finished_routines' => 'rounds#round_finished_routines'
      get 'league' => 'dispute_months#league_points'
      get 'monthly' => 'awards#monthly'
      get 'partials' => 'rounds#partials'
      get 'partials/:id' => 'rounds#partial'
      get 'season_score' => 'seasons#scores'
      get 'search_player/:name' => 'players#search_player'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

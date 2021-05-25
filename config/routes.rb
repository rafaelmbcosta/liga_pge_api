Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  post 'user_token' => 'user_token#create'

  namespace :api do
    namespace :v1 do
      resources :scores
      resources :battles do
        collection do
          get 'details'
        end
      end
      resources :dispute_months do
        collection do
          get 'list'
        end
      end
      resources :rounds do
        collection do
          get 'finished'
        end
      end
      resources :teams do
        collection do
          post 'activation'
          get 'find_team'
        end
      end
      resources :seasons do
        collection do
          get 'current'
        end
      end
      resources :month_activities
      get 'closed_market_routines' => 'rounds#closed_market_routines'
      get 'round_finished_routines' => 'rounds#round_finished_routines'
      get 'general_tasks_routines' => 'rounds#general_tasks_routines'
      get 'active_rounds_progress' => 'rounds#active_rounds_progress'
      get 'championship' => 'awards#championship'
      get 'currencies' => 'currencies#index'
      get 'currencies/rerun' => 'currencies#rerun'
      get 'round_finished_routines' => 'rounds#round_finished_routines'
      get 'league' => 'dispute_months#league_points'
      get 'season_dispute_months' => 'dispute_months#active_rounds'
      get 'monthly' => 'awards#monthly'
      get 'season_score' => 'seasons#scores'
      get 'search_player/:name' => 'players#search_player'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

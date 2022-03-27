Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  post "/graphql", to: "graphql#execute"
  post 'user_token' => 'user_token#create'

  namespace :api do
    namespace :v1 do
      get 'battles', to: 'battles#index'
      get 'battles/details', to: 'battles#details'
      get 'teams', to: 'teams#index'
      get 'teams/find_team', to: 'teams#find_team'
      post 'teams', to: 'teams#create'
      get 'league', to: 'dispute_months#league_points'
      post 'teams/activation', to: 'teams#activation'
      get 'dispute_months', to: 'dispute_months#index'
      get 'currencies', to: 'currencies#index'
      get 'dispute_months/list', to: 'dispute_months#list'
    end
  end
  get 'championship', to: 'awards#championship'
  get 'currencies/rerun', to: 'currencies#rerun'
  get 'season_dispute_months', to: 'dispute_months#active_rounds'
  get 'monthly', to: 'awards#monthly'
  get 'season_score', to: 'seasons#scores'
  get 'search_player/:name', to: 'players#search_player'
  post 'logout', to: 'sessions#logout'
end

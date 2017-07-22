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

      get 'partials' => 'rounds#partials'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

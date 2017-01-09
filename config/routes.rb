Rails.application.routes.draw do
  devise_for :users
  resources :user_stocks, except: [:show, :edit, :update]
  #root "welcome#index"
  #get "my_portfolio" => "users#my_portfolio"
  root "users#my_portfolio"
  get "search_stock" => "stocks#search"
end

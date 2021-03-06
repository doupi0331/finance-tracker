Rails.application.routes.draw do
  # post action之前, 先執行指定的controller
  devise_for :users, :controllers => { :registrations => "user/registrations" }
  resources :user_stocks, except: [:show, :edit, :update]
  resources :users, only: [:show]
  resources :friendships
  root "welcome#index"
  get "my_portfolio" => "users#my_portfolio"
  get "search_stock" => "stocks#search"
  get "my_friends" => "users#my_friends"
  get "search_friends" => "users#search"
  post "add_friend" => "users#add_friend"
end

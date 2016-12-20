Rails.application.routes.draw do
  resources :messages
  devise_for :users
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "users#index"
  post '/record', to: 'users#record'
  #get "/users/:id/edit" , to: "users#edit" 
end

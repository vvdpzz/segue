Segue::Application.routes.draw do
  root :to => 'home#index'
  
  match '/auth/failure' => 'sessions#failure'
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/login' => 'sessions#new', :as => :login
  match '/auth/:provider/callback' => 'sessions#create'
  resources :users, :only => [ :show, :edit, :update ]
end

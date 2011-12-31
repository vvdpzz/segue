Segue::Application.routes.draw do
  root :to => 'home#index'
  
  match '/auth/failure' => 'sessions#failure'
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/signin' => 'sessions#new', :as => :signin
  match '/auth/:provider/callback' => 'sessions#create'
  resources :users, :only => [ :show, :edit, :update ]
end

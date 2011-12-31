Segue::Application.routes.draw do
  root :to => 'home#index'
  
  match '/auth/failure' => 'sessions#failure'
  match '/sign_out' => 'sessions#destroy', :as => :sign_out
  match '/sign_in' => 'sessions#new', :as => :sign_in
  match '/auth/:provider/callback' => 'sessions#create'
  resources :users, :only => [ :show, :edit, :update ]
end

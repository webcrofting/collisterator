Collisterator::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  devise_for :users, 
             :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" },
             :path_names => {:sign_in => "login", :sign_out => "logout"}, 
             :path => "d"


	resources :users

  resources :list_types
  resources :items, except: [:index, :new, :edit]
	resources :item_shares

  match '/jstree', :to => 'items#jstree', :as => 'jstree'

  match '/items/:token' => 'items#show', :as => 'token', :via => [:options]
  
  match '/users/:email' => 'users#show', :as => 'profile'
  
	root :to => "list_types#index" 
end

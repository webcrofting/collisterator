Rails.application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  devise_for :users,
             :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" },
             :path_names => {:sign_in => "login", :sign_out => "logout"},
             :path => "d"


	resources :users

  resources :list_types
  resources :items, except: [:index, :new, :edit]
	resources :item_shares

  get '/jstree', to: 'items#jstree', as: 'jstree'

  get '/items/:token', to: 'items#show', as: 'token', via: [:options]

  get '/users/:email' => 'users#show', :as => 'profile'

	root :to => "list_types#index"
end

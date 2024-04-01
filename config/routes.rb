Rails.application.routes.draw do
  root to: 'tickets#index'
  devise_for :users, skip: [:registrations]

  # resources :tickets, param: :token, only: [:index, :show] do
  #   patch 'enter', on: :member
  # end
  get '/tickets', to: 'tickets#index', as: :tickets
  get '/tickets/new', to: 'tickets#new'
  post '/tickets', to: 'tickets#create'
  match '/tickets/:token/enter', to: 'tickets#enter', via: [:get, :post]
  get '/tickets/:token', to: 'tickets#show', as: :ticket
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

end

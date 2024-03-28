Rails.application.routes.draw do
  root to: 'tickets#index'
  devise_for :users, skip: [:registrations]

  # resources :tickets, param: :token, only: [:index, :show] do
  #   patch 'enter', on: :member
  # end
  get '/tickets', to: 'tickets#index', as: :tickets
  get '/tickets/:token', to: 'tickets#show', as: :ticket
  get '/tickets/:token/enter', to: 'tickets#enter'
  post '/tickets/:token/enter', to: 'tickets#enter'
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

end

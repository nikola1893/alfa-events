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
end

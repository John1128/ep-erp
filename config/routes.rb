Rails.application.routes.draw do
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  root 'contents#index'
  resources :cfdi, only: [:index,:new,:create,:update,:destroy]

  get 'generate_cfdi' => 'cfdi#generate_cfdi'
  post 'cancel_cfdi' => 'cfdi#cancel_cfdi'
  post 'send_cfdi' => 'cfdi#send_cfdi'

  resources :cliente, only: [:show]
  resources :producto, only: [:show]
  resources :facturas
  
end

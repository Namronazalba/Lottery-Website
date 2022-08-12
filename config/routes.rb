Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
    resources :address
    resources :invites
    root :to => 'home#index'
    get 'profile', to: 'home#me'
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      root :to => 'home#index'
      devise_for :users, controllers: { sessions: 'admin/sessions' }
      resources :userlists
    end

  end
end

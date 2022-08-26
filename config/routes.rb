Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
    resources :address
    resources :invites
    root :to => 'home#index'
    get 'profile', to: 'home#me'
    namespace :users, path: '' do
      resources 'lotteries', only: [:show, :index, :create]
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      root :to => 'home#index'
      devise_for :users, controllers: { sessions: 'admin/sessions' }
      resources :userlists
      resources :items
      resources :categories
      resources :bets
      resources :winners do
        put :submit
        put :pay
        put :ship
        put :deliver
        put :publish
        put :remove_publish
      end
    end

  end
end

Rails.application.routes.draw do

  constraints(ClientDomainConstraint.new) do
    devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
    resources 'address',except: :show
    resources :invites
    root :to => 'home#index'
    get 'profile', to: 'home#me'

    namespace :users, path: '' do
      resources 'lotteries', only: [:show, :index, :create]
      resources :shops
      resources :orders, only: [:new, :create] do
        put :cancel
      end
      resources :winners, only: [:show, :update]
      resources :shares
    end
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      root :to => 'home#index'
      devise_for :users, controllers: { sessions: 'admin/sessions' }

      resources :userlists do
        resources :increase, :deduct, :bonus, only: [:create, :new]
      end

      resources :categories
      resources :offers
      resources :newstickers
      resources :banners
      resources :invites, only: :index
      resources :orders do
        put :submit, :cancel, :pay
      end
      resources :items do
        put :start, :pause, :end, :cancel
      end

      resources :bets do
        put :cancel
      end

      resources :winners do
        put :submit, :pay,:ship, :deliver, :publish, :remove_publish
      end
    end
  end
end

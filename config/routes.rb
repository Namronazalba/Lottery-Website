Rails.application.routes.draw do


  constraints(ClientDomainConstraint.new) do
    devise_for :users
    root :to => 'home#index'
  end

  constraints(AdminDomainConstraint.new) do
    namespace :admin, path: '' do
      devise_for :users, controllers: { sessions: 'admin/sessions' }
      root :to => 'home#index'
    end
  end

end

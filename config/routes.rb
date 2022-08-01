Rails.application.routes.draw do
  root :to => "homes#index"


  devise_for :users

  constraints(ClientDomainConstraint.new) do
    get "home" => "homes#index"

  end

  constraints(AdminDomainConstraint.new) do
    get "admin" => "admin#index"
    get "admin" => "admin#login"
  end

end

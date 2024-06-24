Rails.application.routes.draw do
  root 'home#index'

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:index, :new, :create, :edit, :update] do
    get 'registration', on: :member
  end
end

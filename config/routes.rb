Rails.application.routes.draw do
  devise_for :users, :controllers =>{
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
  }
  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    delete 'logout', to: 'users/sessions#destroy'
    get 'sign_up', to: 'users/registrations#new'
  end

  resources :tickets do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end

  root 'homes#index'
end

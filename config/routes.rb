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
  resources :users, only: [:show]
  get '/mypage' => 'users#mypage'

  resources :tickets do
    resources :comments, only: [:create, :destroy]
    resource :likes, only: [:create, :destroy]
    resource :requests, only: [:create, :destroy]
  end

  resources :notifications, only: :index

  resources :rooms, only: [:create, :show, :index]

  root 'homes#index'
end

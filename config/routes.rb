# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get 'login', to: 'users/sessions#new'
    delete 'logout', to: 'users/sessions#destroy'
    get 'sign_up', to: 'users/registrations#new'
    post 'users/guest_sign_in', to: 'users/sessions#guest_user'
  end
  resources :users, only: [:show] do
    member do
      get 'following'
      get 'followers'
      get 'likes'
    end
  end
  get '/mypage' => 'users#mypage'

  resources :tickets do
    resources :comments, only: %i[create destroy]
    resource :likes, only: %i[create destroy]
    resource :requests, only: %i[create destroy]
    member do
      post 'purchase'
    end

  end

  resources :notifications, only: :index
  resources :rooms, only: %i[create show index]
  resources :cards, only: %i[new show destroy create] do
    collection do
      post 'checkout'
    end
  end
  resources :relationships, only: %i[create destroy]

  root 'homes#index'
end

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
  resources :users, only: [:show]
  get '/mypage' => 'users#mypage'

  resources :tickets do
    resources :comments, only: %i[create destroy]
    resource :likes, only: %i[create destroy]
    resource :requests, only: %i[create destroy]
  end

  resources :notifications, only: :index

  resources :rooms, only: %i[create show index]

  # 要確認
  resources :cards, only: [:new, :show, :destroy, :create]

  root 'homes#index'
end

Rails.application.routes.draw do
  devise_for :users, :controllers =>{
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
  }
  devise_scope :user do
    get 'sign_in', to: 'users/sessions#new'
    delete 'sign_out', to: 'users/sessions#destroy'
    get 'sign_up', to: 'users/registrations#new'
  end

  resources :tickets
  root 'tickets#index'
end

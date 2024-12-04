require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "posts#index"

  resources :posts, only: [:index, :new, :create]

  resources :accounts, only: [:show] do
    resources :followings, only: [:index]
    resources :followers, only: [:index]
  end

  resource :profile, only: [:show, :edit, :update]
  resource :timeline, only: [:show]

  namespace :api do
    scope '/posts/:post_id' do
      resources :comments, only: [:index, :create]
      resource :like, only: [:show, :create, :destroy]
    end

    scope '/accounts/:account_id' do
      resources :follows, only: [:create]
      resources :unfollows, only: [:create]
    end
  end
end

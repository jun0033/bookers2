# frozen_string_literal: true

Rails.application.routes.draw do
  get 'chats/show'
  root to: "home#top"
  get "home/about" => "home#about", as: "about"
  get "search" => "searches#search"
  devise_for :users
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  get 'chat/:id', to: 'chats#show', as: 'chat'
  resources :chats, only: [:create]

  resources :books, only: [:new, :index, :show, :create, :destroy, :edit, :update] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:edit, :show, :update, :index] do
    resource :relationships, only: [:create, :destroy]
    get "followings" => "relationships#followings", as: "followings"
    get "followers" => "relationships#followers", as: "followers"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

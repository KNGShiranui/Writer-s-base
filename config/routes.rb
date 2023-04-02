Rails.application.routes.draw do
  root 'repositories#index'
  devise_for :users
  resources :assignees
  resources :branches
  resources :commits
  resources :conversations do
    resources :messages
  end
  resources :documents do
    resources :versions, only: %i[show update], module: :documents
    resources :changes, only: %i[show], module: :documents
  end
  resources :issues
  resources :relationships, only: %i(create destroy) do
    collection do
      get :following
      get :followers 
    end
  end
  resources :repositories 
  resources :users, only: %i(index show)
  resources :favorite_repositories, only: %i(index create destroy)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

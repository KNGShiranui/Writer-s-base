Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :commits
  resources :branches
  resources :assignees
  resources :issues
  devise_for :users
  root 'repositories#index'
  resources :documents do
    resources :versions, only: %i[show update], module: :documents
    resources :changes, only: %i[show], module: :documents
  end
  resources :repositories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

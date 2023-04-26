Rails.application.routes.draw do
  root 'top#index'

  devise_for :users, controllers: {
    sessions: 'sessions',
  }
  devise_scope :user do
    get 'guest_sign_in', to: 'sessions#guest_sign_in'
    # ゲスト管理者機能は除外
    # get 'guest_admin_sign_in', to: 'sessions#guest_admin_sign_in'
    get 'users/edit', to: 'users#edit'
    put 'users', to: 'users#update'
  end

  ## top
  get 'top/index', to: 'top#index'
  get 'top/thanks', to: 'top#thanks'

  ## game
  get 'game', to: 'game#index'
  get 'game/maze', to: 'game#maze'
  get 'game/puzzle', to: 'game#puzzle'
  get 'game/painting', to: 'game#painting'

  resources :assignees
  resources :branches do
    post 'create_from_existing', on: :member
  end  
  resources :commits
  resources :conversations do
    resources :messages
  end
  resources :documents do
    resources :versions, only: %i[show update], module: :documents
    resources :changes, only: %i[show], module: :documents
  end
  resources :issues do
    member do
      patch :toggle_status
    end
  end
  resources :relationships, only: %i(create destroy) do
    collection do
      get :following
      get :followers 
    end
  end
  resources :points, only: %i(new create)
  resources :repositories do
    collection do
      get :search
    end
  end
  resources :users, only: %i(index show update)
  resources :favorite_repositories, only: %i(index create destroy)

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

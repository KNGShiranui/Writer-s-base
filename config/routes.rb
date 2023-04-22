Rails.application.routes.draw do
  root 'top#index'
  ## deviseを使う場合のゲストログイン実装には以下の記載が必要
  devise_for :users, controllers: {
    sessions: 'sessions',
    # ↓deviseで更新しようとすると、なぜかupdateがdestroyになる・・・
    # registrations: 'users/registrations' # user#update用ルーティング
    # ↑users_controllerで制御することにしたので使わない
    # registrations: 'users' # user#update用ルーティング
  }
  ## deviseを使う場合は以下のようにブロックでゲストログインルーティングの記載をする必要あり
  devise_scope :user do
    get 'guest_sign_in', to: 'sessions#guest_sign_in'
    get 'guest_admin_sign_in', to: 'sessions#guest_admin_sign_in'
    get 'users/edit', to: 'users#edit' # users_controllerでupdateを制御することにしたので追記
    put 'users', to: 'users#update' # users_controllerでupdateを制御することにしたので追記
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
  ## newアクションは使わないので書き換え。
  # resources :branches do
  #   post 'create_from_existing', on: :member
  # end
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
  resources :points, only: %i(new create) # point送信用
  resources :repositories do
    collection do
      get :search
    end
  end
  resources :users, only: %i(index show update)
  resources :favorite_repositories, only: %i(index create destroy)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

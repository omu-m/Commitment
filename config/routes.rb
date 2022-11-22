Rails.application.routes.draw do

  namespace :admin do
    get 'comments/index'
  end
  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    root to: "homes#top"
    resources :members, only: [:index, :show, :edit, :update]
    resources :tasks, only: [:index, :show, :edit, :update, :destroy] do
      resources :subtasks, only: [:index, :show, :destroy] do
        resources :comments, only: [:destroy]
      end
      get "index" => "comments#index"
    end
  end

  # 会員用
  # URL /members/sign_in ...
  devise_for :members,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  scope module: :public do
    root to: "homes#top"
    get "/about" => "homes#about", as: "about"
    get "/members/mypage" => "members#show", as: "mypage"
    # members/editのようにするとdeviseのルーティングとかぶってしまうためinformationを付け加えている。
    get "/members/information/edit" => "members#edit", as: "edit_information"
    patch "/members/information" => "members#update", as: "update_information"
    # 退会機能
    get "/members/unsubscribe" => "members#unsubscribe", as: "confirm_unsubscribe"
    put "/members/information" => "members#update"
    patch "/members/withdrawal" => "members#withdrawal", as: "withdrawal_member"
    get "members/:id/task_favorites" => "members#task_favorites", as: "task_favorites"
    get "members/:id/favorites" => "members#favorites", as: "favorites"
    get "tasks/sort_new" => "tasks#sort_tasks", as: "sort_new"
    get "tasks/sort_old" => "tasks#sort_tasks", as: "sort_old"
    resources :activities, only: [:index] do
      # :idが不要の場合
      collection do
        get "checked" => "activities#checked"
        put "update_all" => "activities#update_all"
      end
    end

    resources :tasks, only: [:index, :show, :create, :edit, :update, :destroy] do
      # 親タスク(グループ)
      # get "join" => "tasks#join"
      get "request_join" => "tasks#request_join"
      delete "request_join_destroy" => "tasks#request_join_destroy"
      get "approval_request" => "tasks#approval_request"
      get "non_approval_request" => "tasks#non_approval_request"
      get "applies" => "tasks#applies"
      post "leaving" => "tasks#leaving"
      delete "out" => "tasks#out"
      delete "destroy_all" => "tasks#destroy_all"
      get "search" => "tasks#search"
      resource :task_favorites, only: [:create, :destroy]
      resources :subtasks, only: [:index, :show, :create, :edit, :update, :destroy] do
        get "search" => "subtasks#search"
        # リロードをするとルーティングエラーになる。
        # post "search" => "subtasks#search"
        resource :favorites, only: [:create, :destroy]
        resources :comments, only: [:create, :destroy]
      end
    end
  end

  # ゲストログイン（閲覧用）
  devise_scope :member do
    post "members/guest_sign_in", to: "public/sessions#guest_sign_in", as: "members_guest_sign_in"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

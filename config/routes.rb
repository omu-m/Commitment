Rails.application.routes.draw do
  namespace :admin do
    get 'subtasks/index'
    get 'subtasks/show'
    get 'subtasks/edit'
  end
  namespace :admin do
    get 'tasks/index'
    get 'tasks/show'
    get 'tasks/edit'
  end
  namespace :admin do
    get 'members/index'
    get 'members/show'
    get 'members/unsubscribe'
  end
  namespace :admin do
    get 'homes/top'
  end
  namespace :public do
    get 'subtasks/index'
    get 'subtasks/show'
    get 'subtasks/edit'
  end
  namespace :public do
    get 'tasks/index'
    get 'tasks/show'
    get 'tasks/edit'
  end
  namespace :public do
    get 'members/show'
    get 'members/edit'
    get 'members/unsubscribe'
  end
  namespace :public do
    get 'homes/top'
    get 'homes/about'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # 顧客用
  # URL /members/sign_in ...
  devise_for :members,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
end

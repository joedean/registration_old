Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users
  resources :families
  resources :students do
    resources :courses
  end
  resources :courses do
    resources :students
  end
end

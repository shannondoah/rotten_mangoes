Rails.application.routes.draw do

  root to: 'movies#index'

  resources :movies do 
    resources :reviews, only: [:new, :create]
  end
  
  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]


  namespace :admin do
    resources :users do
      member do 
        put :switch
      end
    end
  end

end

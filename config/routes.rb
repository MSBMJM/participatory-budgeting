Rails.application.routes.draw do
  namespace 'admin' do
    resources :proposals

    match '/suggestions', to: 'proposals#suggestion', via: 'get'
    match '/campaigns', to: 'proposals#campaign', via: 'get'

    resources :campaign
    match '/campaigns', to: 'campaign#create', via: 'post'

        root 'proposals#index'
  end

  namespace 'voting' do
    resources :proposals, only: [:index, :show, :update] do
      collection do
        get 'summarize'
      end
    end

    root 'proposals#index'
  end

  namespace 'monitoring' do
    resources :proposals, only: [:index, :show] do
      collection do
        get 'summarize'
      end
      resources :comments, only: [:create]
    end

    root 'proposals#index'
  end

  namespace 'suggestion' do
    resources :suggestions

    root 'suggestions#new'
  end

  resources :voters, only: [:new, :create, :update] do
    collection do
      get 'verification', to: 'voters#verify', as: :verify
      get 'signout'
    end
  end

  get '/terms-of-service', to: 'pages#terms_of_service'
  get '/privacy-policy',   to: 'pages#privacy_policy'

  root 'pages#home'
end

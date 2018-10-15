Rails.application.routes.draw do
  namespace 'admin' do
    resources :proposals

    match '/suggestions', to: 'proposals#suggestion', via: 'get'
    match '/campaigns', to: 'proposals#campaign', via: 'get'

    resources :campaign
    match '/campaigns', to: 'campaign#create', via: 'post'

    resources :constituency
    match '/constituencies', to: 'constituency#create', via: 'post'

    resources :classifier
    match '/classifiers', to: 'classifier#create', via: 'post'
    # routes to handle classifier children (tag, area, district)
    match '/tag', to: 'classifier#edit', via: 'post'
    match '/area', to: 'classifier#edit', via: 'post'
    match '/district', to: 'classifier#edit', via: 'post'

    match '/tag', to: 'classifier#update', via: 'put'
    match '/area', to: 'classifier#update', via: 'put'
    match '/district', to: 'classifier#update', via: 'put'
    match '/tag', to: 'classifier#update', via: 'patch'
    match '/area', to: 'classifier#update', via: 'patch'
    match '/district', to: 'classifier#update', via: 'patch'


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

                                                                    # helper path identifier
    get '/monitoring-proposals/:id',   to: 'proposals#index' , as: 'campaign_proposals'
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

  get '/constituency',   to: 'pages#constituency'
  get '/constituency-campaign/:id',   to: 'pages#constituency_campaign', as: 'constituency_campaign'

  get 'campaigns', to: 'pages#home'
  # root 'pages#home'


  # root 'pages#constituency'
  root 'pages#home'
end

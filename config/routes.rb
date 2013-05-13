Threethings::Application.routes.draw do
  scope "api/1/" do
    resources :tasks
  end
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  match '*path', to: 'application#index', via: :get
  root to: 'application#index'
end

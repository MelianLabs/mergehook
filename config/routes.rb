Rails.application.routes.draw do
  resources :projects do
    member do
      get "trigger_build/:branch", :to => :trigger_build, :format => false, :constraints => { :branch => /[^\s]+/ }
    end
  end

  devise_for :users, :skip => [:registrations],
                     :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users, only: [:edit, :update]

  resource :github_webhooks, only: :create, defaults: { formats: :json }
  resource :sendgrid_webhooks, only: :create, defaults: { formats: :json }

  root to: "projects#index"
end

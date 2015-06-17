MyBackend::Application.routes.draw do
  defaults format: "json" do

    devise_for :users, controllers: { sessions: 'sessions', passwords: 'passwords', confirmations: 'confirmations' }

    namespace :v1, :defaults => {:format => :json} do

      resources :users, :only => [:update, :destroy,:create, :show]

      resources :accounts

      resources :assignments, :only => [:show, :index,:create, :update, :destroy]  do
        patch "/state", to: "assignments#state", as: :state
      end
      resources :assignment_rewards
      resources :assignment_bids
      resources :resources, :only => [:show, :index,:create, :update, :destroy]
      resources :match_user_users, :only => [:show, :create]
      resources :match_user_resources, :only => [:show, :create]
      resources :affiliations
      resources :intentions
      resources :languages
      resources :locations
      resources :skills
      resource :score_account_assignments do
        get "account_matches"
        get "assignment_matches"
      end
    end
  end

end

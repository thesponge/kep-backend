MyBackend::Application.routes.draw do
  defaults format: "json" do

    devise_for :users, controllers: { sessions: 'sessions', passwords: 'passwords', confirmations: 'confirmations' }

    namespace :v1, :defaults => {:format => :json} do

      resources :users, :only => [:update, :destroy,:create, :show]

      resources :accounts

      resources :assignments, :only => [:show, :index,:create, :update, :destroy]
      resources :assignment_types
      resources :assignment_rewards
      resources :resources, :only => [:show, :index,:create, :update, :destroy]
      resources :matches
      resources :affiliations
      resources :intentions
      resources :languages
      resources :locations
      resources :skills

    end
  end

end

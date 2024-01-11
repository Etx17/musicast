Rails.application.routes.draw do
  get 'tour_requirements/new'
  get 'tour_requirements/create'
  get 'tour_requirements/update'
  get 'tour_requirements/edit'
  get 'tour_requirements/show'

  mount StripeEvent::Engine, at: '/stripe-webhooks'
  resources :leads
  resources :performances
  resources :candidate_programs
  resources :inscriptions do
    resources :inscription_orders, only: [:new, :create]
    resources :performances, only: [:new, :create, :edit, :update]
  end
  resources :imposed_works
  resources :airs
  resources :programme_requirements
  resources :organisms do
    resources :competitions do
      resources :edition_competitions do
        resources :categories do
          resources :tours
          resources :requirement_items
          resources :inscriptions do
            member do
              patch :update_status
            end
          end
          resources :choice_imposed_works
          resources :semi_imposed_works
        end
      end
    end
  end
  resources :partners

  resources :jures
  resources :candidats
  resources :organisateurs

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    # omniauth_callbacks: 'users/omniauth_callbacks'
  }
  root to: "pages#landing"
  get "pages/home", to: 'pages#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/classical_works/composer_search', to: 'classical_works#composer_search'
  get '/classical_works/work_search', to: 'classical_works#work_search'

  # User dashboard
  get 'admin_dashboard', to: 'dashboard#admin'
  get 'organisateur_dashboard', to: 'dashboard#organiser'

  scope 'candidat_dashboard' do
    get '/', to: 'dashboard#candidate', as: 'candidat_dashboard'
    resources :candidatures
  end
  get 'jury_dashboard', to: 'dashboard#jury'
  get 'partner_dashboard', to: 'dashboard#partner'

  resources :edition_competitions, only: [:show] do
    resources :categories, only: [:show] do
      resources :candidatures, only: [:new, :create]
    end
  end

  resources :inscription_orders, only: [:new, :show, :create] do
    resources :payments, only: :new
  end

end

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
    resources :pianist_accompagnateurs
    resources :competitions do
      resources :edition_competitions do
        delete :remove_document, on: :member
        resources :categories do
          resources :prizes
          resources :tours do
            post 'update_order', on: :member
            get 'schedule', on: :member
            put 'update_day_of_performance_and_subsequent_performances', on: :member
            post :shuffle, on: :member
            post :assign_pianist, on: :member
            resources :pauses
            put :qualify_performance, on: :member
            post :assign_pianist_to_performance_manually, on: :member
            get 'move_to_next_tour', on: :member
            get 'show_pdf', on: :member, defaults: { format: 'pdf' }
            get 'show_jury_pdf', on: :member, defaults: { format: 'pdf' }
            post 'store_form_data', on: :member
          end
          resources :requirement_items
          resources :inscriptions do
            member do
              patch :update_status
            end
          end
          resources :choice_imposed_works
          resources :semi_imposed_works
          resources :imposed_works
        end
      end
    end
  end
  resources :partners
  resources :jures
  resources :candidats do
    resources :experiences, only: [:new, :create, :destroy]
    resources :educations, only: [:new, :create, :destroy]
    member do
      post :add_diploma
      delete :delete_diploma
    end
  end
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

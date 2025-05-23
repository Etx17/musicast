Rails.application.routes.draw do

  get '/language/switch', to: 'language#switch', as: 'switch_language'
  # mount StripeEvent::Engine, at: '/stripe-webhooks'

  # Route for changing locale
  get '/change_locale/:locale', to: 'locales#change', as: :change_locale

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    if Rails.env.development?
      get 'make_me_admin/:user_id', to: 'application#make_me_admin', as: :make_me_admin
    end

    # Admin routes
    get 'admin_dashboard', to: 'pages#admin_dashboard'
    post 'admin_create_organism_user', to: 'pages#admin_create_organism_user'
    get 'admin_edition_competitions', to: 'edition_competitions#index', as: 'admin_edition_competitions'
    get 'admin_categories', to: 'categories#index', as: 'admin_categories'
    # Candidate rehearsals routes
    resources :candidate_rehearsals, only: [] do
      member do
        post :update_room
        post :move_up
        post :move_down
      end
    end

    get 'tour_requirements/new'
    get 'tour_requirements/create'
    get 'tour_requirements/update'
    get 'tour_requirements/edit'
    get 'tour_requirements/show'

    resources :leads
    resources :performances do
      member do
        post 'upload_scores'
        delete 'scores/:score_id', to: 'performances#delete_score', as: 'delete_score'
        get 'scores/:score_id/download', to: 'performances#download_score', as: 'download_score'
        get 'download_scores'
      end
    end
    resources :candidate_programs
    resources :inscriptions do
      collection do
        get :start_inscription
      end
      resources :steps, controller: 'inscription_steps' do
        post :upload_item_image, on: :collection
        match :purge_item_image, on: :collection, via: [:get, :post]
      end
      resources :inscription_orders, only: [:new, :create]
      resources :performances, only: [:new, :create, :edit, :update]
      member do
        patch :request_changes
        delete :remove_payment_proof
      end
    end
    resources :imposed_works
    resources :airs
    resources :programme_requirements
    resources :organisms do
      resources :rooms
      member do
        post 'build_and_assign_jury', to: 'juries#build_and_assign_jury'
      end
      resources :organism_juries, only: [:new, :create, :destroy]
      resources :pianist_accompagnateurs
      resources :competitions do
        resources :edition_competitions, except: [:index] do
          delete :remove_document, on: :member
          resources :categories, except: [:index] do
            member do
              get :candidates
            end
            resources :prizes
            resources :tours do
              member do
                delete 'scores/:score_id', to: 'tours#delete_score', as: 'delete_score'
                get 'download_pianist_scores/:pianist_id', to: 'tours#download_pianist_scores', as: :download_pianist_scores
                get 'download_schedule_pdf'
                patch :update_solo_warmup
                patch :update_pianist_rehearsal
                get :download_warmup_schedule
                get :download_pianist_rehearsal_schedule
                get 'download_room_pianist_rehearsal_schedule/:room_id', to: 'tours#download_room_pianist_rehearsal_schedule', as: :download_room_pianist_rehearsal_schedule
              end
              patch :reorder_tours, on: :collection
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
                delete :cancel_performance
              end
            end
            resources :categories_juries
            resources :choice_imposed_works
            resources :semi_imposed_works
            resources :imposed_works
          end
        end
      end
    end
    resources :partners
    resources :juries do
      resources :inscriptions do
        get 'jury_index', on: :collection, as: :jury
        resources :notes, only: [:new, :create, :edit, :update]

      end
    end


    resources :candidats do
      resources :experiences, only: [:new, :create, :destroy]
      resources :educations, only: [:new, :create, :destroy]
      member do
        post :add_diploma
        delete :delete_diploma
        delete :purge_attachment
        delete :purge_portrait
        post :upload_portrait
      end
    end
    resources :organisateurs

    devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions',
      invitations: 'users/invitations'
      # omniauth_callbacks: 'users/omniauth_callbacks'
    }
    root 'pages#home'
    get "pages/home", to: 'pages#home'
    get 'pages/pricing', to: 'pages#pricing'
    get 'pages/terms_of_use', to: 'pages#terms_of_use'
    get 'pages/privacy_policy', to: 'pages#privacy_policy'
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

    get 'category/:category_id/scores', to: 'scores#show', as: :category_scores
    get 'category/:category_id/tours/:tour_id/pianist_scores/:pianist_id/download', to: 'scores#download_pianist_scores', as: :download_category_tour_pianist_scores
    get 'platform_terms', to: 'pages#platform_terms'
  end

  # Redirect root to default locale
  get '/', to: redirect("/#{I18n.default_locale}")
end

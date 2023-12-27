Rails.application.routes.draw do
  resources :leads
  resources :performances
  resources :candidate_program_airs
  resources :candidate_programs
  resources :inscriptions
  resources :semi_imposed_work_airs
  resources :free_choice_airs
  resources :choice_imposed_work_airs
  resources :imposed_work_airs
  resources :semi_imposed_works
  resources :free_choices
  resources :choice_imposed_works
  resources :imposed_works
  resources :airs
  resources :programme_requirements
  resources :requirement_items
  resources :competitions do
    resources :edition_competitions, only: [:new, :create] do
      resources :categories, only: [:new, :create, :destroy] do
        resources :tours
        resources :requirement_items
        resources :inscriptions
      end
    end
  end
  resources :categories
  resources :edition_competitions, only: [:show, :edit, :update, :destroy]
  resources :partners
  resources :organisms
  resources :jures
  resources :candidats
  resources :organisateurs

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    # omniauth_callbacks: 'users/omniauth_callbacks'
  }
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/classical_works/composer_search', to: 'classical_works#composer_search'
  get '/classical_works/work_search', to: 'classical_works#work_search'

  # User dashboard
  get 'admin_dashboard', to: 'dashboard#admin'
  get 'organisateur_dashboard', to: 'dashboard#organiser'
  get 'candidat_dashboard', to: 'dashboard#candidate'
  get 'jury_dashboard', to: 'dashboard#jury'
  get 'partner_dashboard', to: 'dashboard#partner'

end

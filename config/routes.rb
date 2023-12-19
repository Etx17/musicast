Rails.application.routes.draw do
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
  resources :tours
  resources :requirement_items
  resources :categories
  resources :edition_competitions
  resources :competitions
  resources :partners
  resources :organisms
  resources :jures
  resources :candidats
  resources :organisateurs
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

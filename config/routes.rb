Rails.application.routes.draw do
  resources :admins
  resources :instructors
  resources :waitlists
  resources :students
  resources :courses
  resources :enrollments
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

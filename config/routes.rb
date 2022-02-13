Rails.application.routes.draw do
  root 'home#index'
  resources :users
  resources :admins
  resources :instructors
  resources :waitlists
  resources :students
  resources :courses
  resources :enrollments
  resources :sessions, only: [:new, :create, :destroy]
  get 'student_signup', to: "students#new", as: 'student_signup'
  get 'instructor_signup', to: "instructors#new", as: 'instructor_signup'
  get 'login', to: "sessions#new", as: 'login'
  get 'logout', to: "sessions#destroy", as: 'logout'
  get 'mycourses', to: "courses#showinstructorcourses", as: "mycourses"
  get 'student_enrollments', to: "courses#show_student_enrolled_courses", as: "student_enrollments"
  resources :courses do
    member do
      get 'enroll'
    end
  end
  resources :courses do
    member do
      get 'drop'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

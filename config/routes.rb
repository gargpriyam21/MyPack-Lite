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
  get 'instructor_courses', to: "courses#show_instructor_courses", as: "instructor_courses"
  get 'student_enrollments', to: "courses#show_student_enrolled_courses", as: "student_enrollments"
  get 'show_instructor_students_enrolled',  to: "enrollments#show_instructor_students_enrolled", as: "show_instructor_students_enrolled"

  resources :courses do
    member do
      get 'enroll'
    end
  end
  resources :enrollments do
    member do
      get 'unenroll'
    end
  end
  resources :courses do
    member do
      get 'drop'
    end
  end

  resources :courses do
    member do
      get 'all_students'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

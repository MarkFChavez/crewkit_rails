Rails.application.routes.draw do
  get "export/attendance"
  get "export/hours"

  # Landing page for non-authenticated users
  root "landing#index"

  # Waitlist
  post "waitlist", to: "waitlist#create"

  # Authentication
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Signups disabled - use waitlist instead
  # get "signup", to: "users#new"
  # post "signup", to: "users#create"

  # Dashboard
  get "dashboard", to: "dashboard#index"

  # Search
  get "search/team_members", to: "search#team_members"

  # Teams
  resources :teams do
    resources :team_members, except: [:index, :show]
    member do
      patch :archive
      patch :activate
    end
  end

  # Attendance
  get "attendance", to: "attendance#index"
  get "attendance/quick_entry", to: "attendance#quick_entry"
  post "attendance/bulk_update", to: "attendance#bulk_update", as: :bulk_update_attendance
  get "attendance/:id/edit", to: "attendance#edit", as: :edit_attendance_record
  patch "attendance/:id", to: "attendance#update", as: :update_attendance

  # Hours
  get "hours", to: "hours#index"
  post "hours/bulk_update", to: "hours#bulk_update", as: :bulk_update_hours
  get "hours/:id/edit", to: "hours#edit", as: :edit_hours_log
  patch "hours/:id", to: "hours#update", as: :update_hours

  # Export
  get "export/attendance", to: "export#attendance"
  get "export/hours", to: "export#hours"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Route POST requests to /chat to the create action in ChatController
  post '/chat', to: 'chat#create'

  # Health check route (good for deployment later)
  get "up" => "rails/health#show", as: :rails_health_check
end
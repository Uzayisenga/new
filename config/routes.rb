Rails.application.routes.draw do
  devise_for :users
  resources :customers
  get '/search' => 'customer#search'
  resources :customers do
    collection do
      get :export
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

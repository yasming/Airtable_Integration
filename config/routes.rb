Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace 'api' do
    namespace 'v1' do
      get 'copy', action: :index, controller: 'copy'
      get 'copy/refresh', action: :refresh, controller: 'copy'
      get 'copy/:key', action: :show, controller: 'copy', :constraints => { :key => /[^\/]+/ }
    end
  end
end

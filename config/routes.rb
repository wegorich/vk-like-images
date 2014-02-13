ImagesTest::Application.routes.draw do

  resources :albums, exept: :index do
    post 'update_config' => 'albums#update_config'
  end

  devise_for :users, :controllers => {registrations: 'registrations', sessions: 'sessions'}
  devise_scope(:user) { match '/users/sign_up/success' => 'registrations#success' }

  match '/auth/:provider/callback' => 'authorizations#create'
  resources :authorizations, only: [:index, :create, :destroy]
  match '/auth/failure' => 'authorizations#auth_failure'

  resources :users, only: [:show, :edit, :update]

  [:albums].each do |assetable|
    resources assetable do
      resources :assets
    end
  end

  resources :assets, as: :app_assets

  root to: 'users#show'
end

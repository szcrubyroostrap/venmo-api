Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope :user, defaults: { format: :json } do
    post :payment, to: 'users#payment', path: ':id/payment'
    get :feed, to: 'users#feed', path: ':id/feed'
    get :balance, to: 'users#balance', path: ':id/balance'
  end
end

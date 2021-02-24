Rails.application.routes.draw do
  root to: "products#index"
  post 'product/upload', to: 'products#upload'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

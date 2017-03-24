Rails.application.routes.draw do
  get 'expanding_brain/new'

  post 'expanding_brain/create'

  get 'expanding_brain/show'

  get 'brain/new'

  get 'brain/create'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

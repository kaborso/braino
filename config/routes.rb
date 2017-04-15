Rails.application.routes.draw do
  root to: 'expanding_brain#new'

  get 'expanding_brain/new'


  get 'expanding_brain.json',     to: 'expanding_brain#show_json'
  post 'expanding_brain.json',    to: 'expanding_brain#post_json'

  post 'expanding_brain/create'

  get 'expanding_brain/show/',    to: redirect('/')

  get 'expanding_brain/show/:id', to: 'expanding_brain#show'
end

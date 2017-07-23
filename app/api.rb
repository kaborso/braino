class API < Grape::API
  rescue_from :all
  helpers do
    def logger
      API.logger
    end
  end
  version 'v1', using: :header, vendor: 'braino'
  format :json
  default_format :json
  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error!({error: e.message}, 400)
  end

  desc 'Retrieve the url for a generated expanding brain image'
  params do
    requires :id, type: String, allow_blank: false
    exactly_one_of :id
  end
  get '/expanding_brain' do
    begin
      {
        url: Storage.get_image_url(params[:id])
      }
    rescue => e
      logger.error e.message
      status 404
      {error: "could not get url for #{params[:id]}"}
    end
  end

  desc 'Generate an expanding brain image'
  params do
    requires :brains, type: Array, allow_blank: false do
      requires :text, type: String
    end
    exactly_one_of :brains
  end
  post '/expanding_brain' do
    brains = params[:brains].map do |brains|
      brains[:text]
    end
    braino = ExpandingBrain.generate(brains)
    {
      name: braino.name,
      url: braino.url
    }
  end

  desc 'Handle bad routes'
  route :any, '*' do
    error!({ error: 'Not found' }, 404)
  end
end

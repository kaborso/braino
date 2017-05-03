class API < Grape::API
  rescue_from :all
  helpers do
    def logger
      API.logger
    end
  end
  version 'v1', using: :header, vendor: 'braino'
  format :json
  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error!({error: e.message}, 400)
  end

  desc 'Get the url for a generated brain meme'
  params do
    requires :id, type: String, allow_blank: false
    exactly_one_of :id
  end
  get '/expanding_brain.json' do
    begin
      url = Storage.get_image_url('blah')
      { url: url }

    rescue => e
      logger.error e.message
      status 404
      {error: "could not get url for #{params[:id]}"}
    end
  end

  desc 'Generate a brain meme'
  params do
    requires :brains, type: Array, allow_blank: false do
      requires :text, type: String
    end
    exactly_one_of :brains
  end
  post '/expanding_brain.json' do
    braino = ExpandingBrain.generate(params[:brains])
    {
      name: braino.name,
      url: braino.url
    }
  end

  route :any, '*path' do
    error!({ error: 'Not found' }, 404)
  end
end

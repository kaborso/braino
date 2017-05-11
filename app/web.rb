class Web < Sinatra::Base
  include Metrics

  get '/' do
    erb :new, :layout => :application
  end

  post '/' do
    begin
      @url = ExpandingBrain.generate(params[:brains])
      erb :show, :layout => :application
    rescue => e
      logger.error e.message
      'Could not generate image.'
    end
  end

  get '/show/:image_id' do
    begin
      key_name = "#{params[:id]}.png"
      @url = Storage.get_image_url(key_name)
      erb :show, :layout => :application
    rescue => e
      logger.error e.message
      'Could not retrieve image.'
    end
  end

  not_found do
    case request.content_type
    when "application/json"
      [404, {"errors": [{"detail":"Not found"}]}.to_json]
    else
      [404, 'Not found']
    end
  end

  error do
    logger.error 'Error: ' + env['sinatra.error'].message
    'An error occurred.'
  end
end

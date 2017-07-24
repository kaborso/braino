class Web < Sinatra::Base
  include Metrics

  get '/' do
    erb :new, :layout => :application
  end

  get '/show/:image_id?' do
    begin
      raise ArgumentError unless params[:image_id]
      key_name = "#{params[:image_id]}.png"
      @url = Storage.get_image_url(key_name)
      erb :show, :layout => :application
    rescue ArgumentError => e
      logger.error e.message
      [400, 'Missing image ID parameter']
    rescue => e
      logger.error e.message
      [404]
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

class Web < Sinatra::Base
  include Metrics

  get '/' do
    erb :new, :layout => :application
  end

  post '/' do
    @url = ExpandingBrain.generate(params[:brains]).url
    erb :show, :layout => :application
  end

  get '/show/:image_id' do
    key_name = "#{params[:id]}.png"
    @url = Storage.get_image_url(key_name)
    erb :show, :layout => :application
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
    puts 'Error: ' + env['sinatra.error'].message
    'An error occurred.'
  end
end

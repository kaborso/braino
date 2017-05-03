class Web < Sinatra::Base
  include Metrics

  get '/' do
    erb :new, :layout => :application
  end

  get '/show/:image_id' do
    s3 = Aws::S3::Client.new(region: 'us-east-2')
    signer = Aws::S3::Presigner.new(client: s3)
    key_name = "#{params[:image_id]}.png"
    @url = signer.presigned_url(:get_object, bucket: "expanding-brain", key: key_name)
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

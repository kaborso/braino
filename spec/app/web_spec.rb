describe 'expanding brain site' do
  include Rack::Test::Methods

  def app
    @app = Web
  end

  describe 'get /' do
    it 'returns 200' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe '404' do
    it 'returns 404' do
      get '/blah'
      expect(last_response.body).to eq("Not found")
      expect(last_response.status).to eq(404)
    end
  end

  describe '404.json' do
    it 'returns json' do
      header 'Accept', 'application/json'
      header 'Content-Type', 'application/json'

      get '/blah'
      expect(last_response.body).to eq '{"errors":[{"detail":"Not found"}]}'
      expect(last_response.status).to eq(404)
    end
  end
end

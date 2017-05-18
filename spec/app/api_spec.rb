describe 'braino' do
  describe 'get /expanding_brain.json' do
    it 'validates type' do
      VCR.use_cassette('aws_test_png') do
        get '/expanding_brain.json?id=test.png'
        expect_status 200
        expect_json_types(url: :string)
      end
    end

    it 'returns presigned_url' do
      VCR.use_cassette('aws_test_png') do
        get '/expanding_brain.json?id=test.png'
        expect_status 200
        expect_json(url: regex("https://expanding-brain.s3.us-east-2.amazonaws.com/test.png"))
      end
    end

    it 'returns error when no "id" param' do
      get '/expanding_brain.json'
      expect_status 400
      expect_json_types(error: :string)
      expect_json(error: "id is missing, id is empty")
    end

    it 'returns error when no image found for "id" param' do
      VCR.use_cassette('aws_not_found') do
        get '/expanding_brain.json?id=DoesNotExist'
        expect_status 404
        expect_json_types(error: :string)
        expect_json(error: "could not get url for DoesNotExist")
      end
    end
  end

  describe 'post /expanding_brain.json' do
    before(:each) do
      braino = double('ExpandingBrain')
      allow(braino).to receive_messages({
        name: 'something',
        url: 'https://whatever/something'
      })
      allow(ExpandingBrain).to receive(:generate).and_return(braino)
    end

    it 'validates type' do
      post '/expanding_brain.json', {"brains" => [{text:"a"}, {text:"b"}, {text:"c"}, {text:"d"}]}.to_json, { 'accept' => 'application/json', 'content-type' => 'application/json' }
      expect_status 201
      expect_json_types(:name => :string, :url => :string)
    end

    it 'returns "name" and "url"' do
      post '/expanding_brain.json', {"brains" => [{text:"a"}, {text:"b"}, {text:"c"}, {text:"d"}]}.to_json, { 'accept' => 'application/json', 'content-type' => 'application/json' }
      expect_status 201
      expect_json(name:'something', url: 'https://whatever/something')
    end

    it 'returns error when no "brains" param' do
      post '/expanding_brain.json', {something: :else}.to_json, { 'accept' => 'application/json', 'content-type' => 'application/json' }
      expect_status 400
      expect_json_types(error: :string)
      expect_json(error: 'brains is missing, brains is empty')
    end

    it 'returns error when "brains" param is not array of strings' do
      post '/expanding_brain.json', {brains: "not an array"}.to_json, { 'accept' => 'application/json', 'content-type' => 'application/json' }
      expect_status 400
      expect_json_types(error: :string)
      expect_json(error: 'brains is invalid')
    end
  end

  describe 'bad route' do
    it 'returns 404' do
      get '/nonexistent'
      expect_status 404
      expect_json_types(error: :string)
      expect_json(error: 'Not found')
    end
  end
end

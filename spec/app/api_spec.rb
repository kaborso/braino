describe 'braino' do
  describe 'get /expanding_brain.json' do
    before(:each) do
      aws_response = double('AWS')
      allow(aws_response).to receive_messages({
        url: 'https://whatever/something'
      })
      allow(Aws::S3::Client).to receive(:new).and_return(aws_response)
      allow(Storage).to receive(:get_image_url).and_return('http://someawsurl/fortheimageblah')
    end

    it 'validates type' do
      get '/expanding_brain.json?id=blah'
      expect_status 200
      expect_json_types(url: :string)
    end

    it 'returns presigned_url' do
      get '/expanding_brain.json?id=blah'
      expect_status 200
      expect_json(url: 'http://someawsurl/fortheimageblah')
    end

    it 'returns error when no "id" param' do
      get '/expanding_brain.json'
      expect_status 400
      expect_json_types(error: :string)
      expect_json(error: "id is missing, id is empty")
    end

    it 'returns error when no image found for "id" param' do
      allow(Storage).to receive(:get_image_url).and_raise(StandardError)
      get '/expanding_brain.json?id=NotOnS3'
      expect_status 404
      expect_json_types(error: :string)
      expect_json(error: "could not get url for NotOnS3")
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

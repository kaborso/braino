describe 'storage module' do
  let (:aws_object) { double('AWS') }

  describe 'upload_image method' do
    before(:each) do
      allow(aws_object).to receive(:put_object).and_return(true)
      allow(File).to receive(:open).and_yield('fake/file/path')
      allow(Aws::S3::Client).to receive(:new).and_return(aws_object)
    end

    it 'returns key name' do
      expect(Storage.upload_image('some_image', 'path')).to eq('some_image.png')
    end

    describe 'raises error' do
      it 'if the file cannot be opened' do
        allow(File).to receive(:open).and_raise(IOError)
        expect{ Storage.upload_image('name', 'path') }.to raise_error(Storage::StorageError)
      end

      it 'if AWS responds with an error' do
        allow(Aws::S3::Client).to receive(:new).and_raise(StandardError)
        expect{ Storage.upload_image('name', 'path') }.to raise_error(Storage::StorageError)
      end
    end
  end

  describe 'get_image_url method' do
    it 'returns url' do
      VCR.use_cassette("aws_test_png") do
        expect(Storage.get_image_url('test.png')).to match('https://expanding-brain.s3.us-east-2.amazonaws.com/test.png')
      end
    end

    describe 'raises error' do
      before(:each) do
        allow(aws_object).to receive(:exists?).and_return(true)
        allow(aws_object).to receive(:presigned_url).and_return(true)
        allow(Aws::S3::Client).to receive(:new).and_return(nil)
        allow(Aws::S3::Object).to receive(:new).and_return(aws_object)
      end

      it 'if object does not exist' do
        allow(aws_object).to receive(:exists?).and_return(false)
        expect{ Storage.get_image_url('some_key') }.to raise_error(Storage::StorageError)
      end

      it 'if AWS responds with an error' do
        allow(Aws::S3::Client).to receive(:new).and_raise(StandardError)
        expect{ Storage.get_image_url('some_key') }.to raise_error(Storage::StorageError)

      end
    end
  end
end

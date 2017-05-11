module Storage
  def self.upload_image(name, path)
    begin
      key_name = "#{name}.png"
      s3 = Aws::S3::Client.new(region: 'us-east-2')
      File.open(path, 'rb') do |file|
        s3.put_object(bucket: 'expanding-brain', key: key_name, body: file)
      end
      key_name
    rescue => e
      raise StorageError, "Could not upload image -- #{e.message}"
    end
  end

  def self.get_image_url(key_name)
    begin
      s3 = Aws::S3::Client.new(region: 'us-east-2')
      signer = Aws::S3::Presigner.new(client: s3)
      @url = signer.presigned_url(:get_object, bucket: "expanding-brain", key: key_name)
    rescue => e
      raise StorageError, "Could not get image url -- #{e.message}"
    end
  end

  class StorageError < StandardError; end
end

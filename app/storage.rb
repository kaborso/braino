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
      obj = Aws::S3::Object.new(client: s3, bucket_name: "expanding-brain", key: key_name)
      if obj.exists?
        return obj.presigned_url(:get)
      else
        raise StorageError, "Image does not exist"
      end
    rescue => e
      raise StorageError, "Could not get image url -- #{e.message}"
    end
  end

  class StorageError < StandardError; end
end

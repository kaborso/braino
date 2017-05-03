module Storage
  def self.get_image_url(name)
    # s3 = Aws::S3::Client.new(region: 'us-east-2')
    # signer = Aws::S3::Presigner.new(client: s3)
    # key_name = "#{params[:id]}.png"
    # @url = signer.presigned_url(:get_object, bucket: "expanding-brain", key: key_name)
  end

  def upload_image(name, path)
    # key_name = "#{name}.png"
    # s3 = Aws::S3::Client.new(region: 'us-east-2')
    # File.open(path, 'rb') do |file|
    #   s3.put_object(bucket: 'expanding-brain', key: key_name, body: file)
    # end
  end
end

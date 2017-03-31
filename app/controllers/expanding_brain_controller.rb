require 'aws-sdk'

class ExpandingBrainController < ApplicationController
  def index
  end

  def new
  end

  def create
    brains = params["expanding_brain"]
    @brains = ExpandingBrain.new(brains["brain_1"], brains["brain_2"], brains["brain_3"], brains["brain_4"]).generate
    redirect_to @brains.url, status: 303 # redirect_to "/expanding_brain/show/#{@brains.name}/", status: 303 # Use this with websockets and the queue
  end

  def show
    s3 = Aws::S3::Client.new(region: 'us-east-2')
    signer = Aws::S3::Presigner.new(client: s3)
    key_name = "#{params[:id]}.png"
    @url = signer.presigned_url(:get_object, bucket: "expanding-brain", key: key_name)
  end
end

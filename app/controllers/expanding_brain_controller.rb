require 'aws-sdk'
require 'socket'

class ExpandingBrainController < ApplicationController
  def index
  end

  def new
    conn = TCPSocket.new 'a49e7bd5.carbon.hostedgraphite.com', 2003
    conn.puts "5afc0669-ed8f-49f2-8ada-4bf7bac69c57.#{ENV['RAILS_ENV']}.visit 1 #{Time.now.to_i}\n"
    conn.close
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

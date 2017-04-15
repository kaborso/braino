require 'aws-sdk'
require 'socket'
require 'uri'

class ExpandingBrainController < ApplicationController
  include ExpandingBrainHelper
  protect_from_forgery unless: -> { request.format.json? }

  def index
  end

  def new
    track('visit', 1)
  end

  def create
    brains = params["expanding_brain"]
    @brains = ExpandingBrain.new(brains["brain_1"] || "",
                                 brains["brain_2"] || "",
                                 brains["brain_3"] || "",
                                 brains["brain_4"] || "").generate
    redirect_to @brains.url, status: 303 # redirect_to "/expanding_brain/show/#{@brains.name}/", status: 303 # Use this with websockets and the queue
  end

  def show
    s3 = Aws::S3::Client.new(region: 'us-east-2')
    signer = Aws::S3::Presigner.new(client: s3)
    key_name = "#{params[:id]}.png"
    @url = signer.presigned_url(:get_object, bucket: "expanding-brain", key: key_name)
  end

  def show_json
    errors = []
    errors << {"detail": "Missing 'id' field"} unless params.key? 'id'

    if errors.length > 0
      render 400, json: {"errors": errors} and return
    else
      s3 = Aws::S3::Client.new(region: 'us-east-2')
      signer = Aws::S3::Presigner.new(client: s3)
      key_name = "#{params[:id]}.png"
      url = signer.presigned_url(:get_object, bucket: "expanding-brain", key: key_name)
      render json: { url: url }
    end
  end

  def post_json
    brains = []
    errors = []

    begin
    track('api', 1)
    if params.key? 'brains'
      brains = params["brains"]
      if brains.is_a? Array
        errors << {'detail': 'Brains field should be an array of strings.'} unless brains.all? {|brain| brain.is_a? String }
      else
        errors << {'detail': 'Brains field should be an array of strings.'}
      end
    else
      errors << {'detail': 'Missing "brains" field'}
    end

    if errors.length > 0
      render 400, json: {'errors': errors} and return
    else
      expanding_brain = ExpandingBrain.new(brains).generate
      render json: { id: expanding_brain.name, url: expanding_brain.url }.to_json and return
    end
    rescue => e
      logger.error e.message
      e.backtrace.each { |line| logger.error line }
      errors << {'detail': 'Internal server error'}
      render 500, json: {'errors': errors} and return
    end
  end
end

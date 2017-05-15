if !ENV['AWS_ACCESS_KEY_ID'] || !ENV['AWS_SECRET_ACCESS_KEY']
  puts 'Missing aws credentials!'
  exit
end

require 'securerandom'
require 'json'
require "shellwords"
require 'aws-sdk'
require 'mini_magick'
require 'socket'
require 'uri'
require 'grape'
require 'sinatra'

require 'metrics'
require 'storage'

class API < Grape::API
  extend Metrics
  extend Storage

end

require 'models/brain'
require 'models/expanding_brain'

require 'api'
require 'web'

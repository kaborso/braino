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

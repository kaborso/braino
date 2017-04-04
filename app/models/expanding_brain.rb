require 'securerandom'
require 'json'
require "shellwords"
require 'aws-sdk'
require 'mini_magick'
require 'socket'

class ExpandingBrain < ApplicationRecord
  has_many :brains
  attr_reader :name, :url, :first, :second, :third, :fourth
  attr_reader

  def initialize(first, second, third, fourth)
    @name = SecureRandom.urlsafe_base64(9)
    @first = Brain.new(first)
    @second = Brain.new(second)
    @third = Brain.new(third)
    @fourth =  Brain.new(fourth)
    @init_time = Time.now.to_i
    @generate_time = 0
    @upload_time = 0
  end

  def self.perform

  end

  def generate
    logger.debug Dir.pwd
    logger.debug "#{File.exists?('lib/assets/brain_meme.jpg')}"

    Dir.mktmpdir do |tmpdir|
      path = ""

      begin
        path = "#{tmpdir}/#{name}.png"
        logger.debug "Running ImageMagick on #{path}"
        img1 = MiniMagick::Tool::Convert.new do |convert|
          convert << "lib/assets/brain_meme.jpg"
          convert.merge! ["-font", "#{::Rails.root}/public/fonts/Impact.ttf"]
          convert.merge! ["-pointsize", "32"]
          convert.merge! ["-size", "410x295"]
          convert.merge! ["-gravity", "center"]
          convert.merge! ["-page", "+2+0"]
          convert.merge! ["caption:#{@first}"]
          convert.merge! ["-flatten"]
          convert.merge! ["#{path}1"]
        end

        img2 = MiniMagick::Tool::Convert.new do |convert|
          convert << "#{path}1"
          convert.merge! ["-font", "#{::Rails.root}/public/fonts/Impact.ttf"]
          convert.merge! ["-pointsize", "32"]
          convert.merge! ["-size", "410x295"]
          convert.merge! ["-gravity", "center"]
          convert.merge! ["-page", "+2+305"]
          convert.merge! ["caption:#{@second}"]
          convert.merge! ["-flatten"]
          convert.merge! ["#{path}2"]
        end

        img3 = MiniMagick::Tool::Convert.new do |convert|
          convert << "#{path}2"
          convert.merge! ["-font", "#{::Rails.root}/public/fonts/Impact.ttf"]
          convert.merge! ["-pointsize", "32"]
          convert.merge! ["-size", "410x270"]
          convert.merge! ["-gravity", "center"]
          convert.merge! ["-page", "+2+610"]
          convert.merge! ["caption:#{@third}"]
          convert.merge! ["-flatten"]
          convert.merge! ["#{path}3"]
        end

        img4 = MiniMagick::Tool::Convert.new do |convert|
          convert << "#{path}3"
          convert.merge! ["-font", "#{::Rails.root}/public/fonts/Impact.ttf"]
          convert.merge! ["-pointsize", "32"]
          convert.merge! ["-size", "410x300"]
          convert.merge! ["-gravity", "center"]
          convert.merge! ["-page", "+2+895"]
          convert.merge! ["caption:#{@fourth}"]
          convert.merge! ["-flatten"]
          convert.merge! ["#{path}"]
        end
      rescue StandardError => e
        logger.debug e.inspect
        track("error", 1)

        # requeue
      end

      if File.exist?(path)


        logger.debug "Successfully processed #{path}"
        @generate_time = Time.now.to_i
        track("image.generate.timer", @generate_time - @init_time)

        begin
          # Put image on S3
          key_name = "#{name}.png"
          s3 = Aws::S3::Client.new(region: 'us-east-2')
          File.open(path, 'rb') do |file|
            s3.put_object(bucket: 'expanding-brain', key: key_name, body: file)
          end

          logger.debug "Placed #{path} on S3"
          @upload_time = Time.now.to_i
          track("image.upload.timer", @upload_time - @generate_time)


          # Get a public url for the image
          signer = Aws::S3::Presigner.new(client: s3)
          @url = signer.presigned_url(:get_object, bucket: "expanding-brain", key: key_name)
        rescue StandardError => e
          logger.debug e.inspect
          track("error", 1)

          # logger.debug e.backtrace
        end
      else
        logger.debug "Could not generate image."
      end
    end
    self
  end
  private
  def track(metric, value)
    logger.debug "#{metric}: #{value}"
    conn = TCPSocket.new 'a49e7bd5.carbon.hostedgraphite.com', 2003
    conn.puts "5afc0669-ed8f-49f2-8ada-4bf7bac69c57.#{ENV['RAILS_ENV']}.#{metric} #{value} #{Time.now.to_i}\n"
    conn.close
  end
end

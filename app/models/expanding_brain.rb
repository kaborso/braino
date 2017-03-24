require 'securerandom'
require 'json'
require "shellwords"
require 'aws-sdk'

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
  end

  def self.perform

  end

  def generate
    logger.debug Dir.pwd
    logger.debug "#{File.exists?('lib/assets/brain_meme.jpg')}"

    Dir.mktmpdir do |tmpdir|
      path = ""
      cmd = ""
      res = nil
      begin
        path = "#{tmpdir}/#{name}.png"
        logger.debug "Running ImageMagick on #{path}"
        logger.debug "Where is this"
        cmd = "convert lib/assets/brain_meme.jpg -font Impact -pointsize 36" \
              << "-size 285x410 -annotate +2+40 '#{@first}'" \
              << " -size 285x410 -annotate +2+340 '#{@second}'" \
              << "-size 285x410 -annotate +2+650 '#{@third}'" \
              << "-size 285x410 -annotate +2+930 '#{@fourth}'" \
              << " #{path}"
        puts cmd
        logger.debug cmd
        res = `convert lib/assets/brain_meme.jpg -font Impact -pointsize 36 \
            -size 285x410 -annotate +2+40 "#{@first.to_s.shellescape}" \
            -size 285x410 -annotate +2+340 "#{@second.to_s.shellescape}" \
            -size 285x410 -annotate +2+650 "#{@third.to_s.shellescape}" \
            -size 285x410 -annotate +2+930 "#{@fourth.to_s.shellescape}" \
             #{path}`
      rescue StandardError => e
        logger.debug e.inspect
        # logger.debug e.backtrace[0]

        logger.debug "Failed (#{cmd})"
        logger.debug "Failed (#{res})"

        # requeue
      end

      if File.exist?(path)
        logger.debug "Successfully processed #{path}"

        begin
          # post to s3

          logger.debug "Putting #{path} on S3"

          s3 = Aws::S3::Client.new(region: 'us-east-2')
          File.open(path, 'rb') do |file|
            s3.put_object(bucket: 'expanding-brain', key: name, body: file)
          end

          signer = Aws::S3::Presigner.new(client: s3)
          @url = signer.presigned_url(:get_object, bucket: "expanding-brain", key: name)
          logger.debug "Image is ready at #{@url}"

        rescue StandardError => e
          logger.debug e.inspect
          # logger.debug e.backtrace
        end
      else
        logger.debug "Could not generate image."
      end
    end
    self
  end
end

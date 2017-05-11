class ExpandingBrain
  include Metrics

  attr_reader :name, :url, :first, :second, :third, :fourth

  def initialize(brains)
    first, second, third, fourth = brains
    @name = SecureRandom.urlsafe_base64(9)
    @first = Brain.new(first, pane:"410x295", page:"+2+0")
    @second = Brain.new(second, pane:"410x295", page:"+2+305")
    @third = Brain.new(third, pane: "410x270", page:"+2+610")
    @fourth =  Brain.new(fourth, pane: "410x300", page:"+2+895")
    @init_time = Time.now.to_i
    @generate_time = 0
    @upload_time = 0
  end

  def self.generate(brains)
    ExpandingBrain.new(brains).tap { |_| _.generate }
  end

  def generate
    path = ""

    Dir.mktmpdir do |tmpdir|

      begin
        base_path = "lib/assets/brain_meme.jpg"
        path = "#{tmpdir}/#{name}.png"
        # logger.debug "Running ImageMagick on #{path}"

        first.render(base_path, "#{path}1", )
        second.render("#{path}1", "#{path}2")
        third.render("#{path}2", "#{path}3")
        fourth.render("#{path}3", path)

      rescue StandardError => e
        track("error", 1)
        raise ExpandingBrainError, "Failed to generate image -- #{e.message}"
      end

      if File.exist?(path)
        # logger.debug "Successfully processed #{path}"
        @generate_time = Time.now.to_i
        track("image.generate.timer", @generate_time - @init_time)

        begin
          # Put image on S3
          key_name = Storage.upload_image(name, path)

          # logger.debug "Placed #{path} on S3"
          @upload_time = Time.now.to_i
          track("image.upload.timer", @upload_time - @generate_time)

          # Get a public url for the image
          @url = Storage.get_image_url(key_name)
        rescue StandardError => e
          track("error", 1)
          raise ExpandingBrainError, "Failed to finalize image -- #{e.message}"
        end
      else
        raise ExpandingBrainError, "Failed to find generated image -- file does not exist."
      end
    end
  end
end

class ExpandingBrainError < StandardError; end

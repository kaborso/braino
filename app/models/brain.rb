class Brain
  include Metrics

  attr_reader :pointsize
  attr_reader :pane
  attr_reader :page
  attr_reader :text
  attr_reader :max_line_length
  attr_reader :max_text_length

  LARGEST_POINTSIZE = 72
  GREATER_POINTSIZE = 48
  DEFAULT_POINTSIZE = 36
  SMALLER_POINTSIZE = 24
  TINIEST_POINTSIZE = 12

  # Pane sizes
  # "410x295"
  # "410x295"
  # "410x270"
  # "410x300"

  # Pane positions
  # +2+0
  # +2+305
  # +2+610
  # +2+895

  def initialize(text, pointsize: DEFAULT_POINTSIZE, pane: "", page: "")
    @pointsize = pointsize
    @pane = pane
    @page = page

    set_limits

    @text = process(text || '')
  end

  def to_s
    @text
  end

  def render(input, output)
    begin
      MiniMagick::Tool::Convert.new do |convert|
        convert << input
        convert.merge! ["-font", "lib/assets/Impact.ttf"]
        convert.merge! ["-pointsize", pointsize]
        convert.merge! ["-size", pane]
        convert.merge! ["-gravity", "center"]
        convert.merge! ["-page", page]
        convert.merge! ["caption:#{text}"]
        convert.merge! ["-flatten"]
        convert.merge! [output]
      end
      return output
    rescue StandardError => e
      track("error", 1)
      raise BrainError, "failed to render brain image (#{output}) -- #{e.message}"
    end
  end

  private
  def process(text)
    text[0...max_text_length].split(' ').reduce([]) do |counted_text, current_word|
      if counted_text.empty?
        if current_word.length <= max_line_length
          counted_text.push current_word
        else
          more_text = current_word.split('').reduce(['']) do |shortened_words, character|
            if shortened_words[shortened_words.length-1].length < max_line_length
              shortened_words[shortened_words.length-1] << character
            else
              shortened_words.push character
            end
            shortened_words
          end
          counted_text.concat more_text
        end
      else
        if (counted_text.last.length + current_word.length) < max_line_length
          counted_text[counted_text.length - 1] << ' ' << current_word
        else
          counted_text.push current_word
        end
      end
      counted_text
    end.join "\n"
  end

  def set_limits
    case pointsize
    when LARGEST_POINTSIZE
    when GREATER_POINTSIZE
    when DEFAULT_POINTSIZE
      @max_line_length = 30
      @max_text_length = 180
    when SMALLER_POINTSIZE
    when TINIEST_POINTSIZE
    else
      @max_line_length = 30
      @max_text_length = 180
    end
  end

end

class BrainError < StandardError; end

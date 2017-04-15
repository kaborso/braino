require 'test_helper'

class BrainTest < ActiveSupport::TestCase

  test "splits up long text with carriage returns every 30 characters" do
    loooooong_text = "Here's some text with a looooooooooooong word in the first thirty characters."
    multiline_text = "Here's some text with a\nlooooooooooooong word in the\nfirst thirty characters."

    assert_equal "#{Brain.new(loooooong_text)}", multiline_text
  end

  test "splits up long, spaceless text with carriage returns every 30 characters" do
    loooooong_text = "Here'ssometextwithoutanyspacesjusttomakesurethisstillworks."
    multiline_text = "Here'ssometextwithoutanyspaces\njusttomakesurethisstillworks."

    assert_equal "#{Brain.new(loooooong_text)}", multiline_text
  end

  test "truncates 36pt text longer than 180 characters" do
    right_length = 180
    lots_of_text =  "Here's a whole lot of text that definitely will not fit in " \
                <<  "any of the boxes on the expanding brain meme image at 36pt " \
                <<  "Impact font. The max is 6 lines of 30 characters each: 180 " \
                <<  "maximum. Don't worry, we will soon support even more sizes."
    assert_equal right_length, "#{Brain.new(lots_of_text)}".length
  end

  test "handles nil" do
    assert_equal "", "#{Brain.new(nil)}"
  end
end

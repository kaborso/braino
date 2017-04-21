require 'test_helper'

class ExpandingBrainTest < ActiveSupport::TestCase
  test "initializiation of ExpandingBrain" do
    brains = ["first", "second", "third", "fourth"]
    eb = ExpandingBrain.new(brains)
    assert_equal "first", eb.first.to_s
    assert_equal "second", eb.second.to_s
    assert_equal "third", eb.third.to_s
    assert_equal "fourth", eb.fourth.to_s
  end
end

require 'test_helper'

class ExpandingBrainControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get expanding_brain_new_url
    assert_response :success
  end

  test "should post create" do
    post expanding_brain_create_url, params: {expanding_brain: {brain_1: "", brain_2: "", brain_3: "", brain_4: ""}}
    assert_response :success
  end

  test "should get show" do
    get expanding_brain_show_url
    assert_response :success
  end

end

require 'test_helper'

class ExpandingBrainControllerTest < ActionDispatch::IntegrationTest
  def setup
    @get_mock = Minitest::Mock.new
    def @get_mock.presigned_url(*args)
      'https://whatever/bklwerjp'
    end

    @post_mock = Minitest::Mock.new
    def @post_mock.generate(*args)
      brain_mock = Minitest::Mock.new
      brain_mock.expect :name, 'something'
      brain_mock.expect :url, 'https://whatever/something'
      brain_mock
    end
  end

  # test "gets /new/" do
  #   get expanding_brain_new_url
  #   assert_response :success
  # end
  #
  # test "posts /create/" do
  #   post expanding_brain_create_url, params: {expanding_brain: {brain_1: "", brain_2: "", brain_3: "", brain_4: ""}}
  #   assert_response :success
  # end

  # test "gets /show/" do
  #   get expanding_brain_show_url
  #   assert_response :success
  # end

  test "gets /expanding_brain.json" do
    Aws::S3::Client.stub :new, Minitest::Mock.new do
      Aws::S3::Presigner.stub :new, @get_mock do
        get '/expanding_brain.json?id=bklwerjp'
        # assert_response :success
        assert_equal "application/json", @response.content_type
      end
    end
  end

  test "returns presigned_url" do
    Aws::S3::Client.stub :new, Minitest::Mock.new do
      Aws::S3::Presigner.stub :new, @get_mock do
        get '/expanding_brain.json?id=bklwerjp'
        assert_equal '{"url":"https://whatever/bklwerjp"}', @response.body
      end
    end
  end

  test "returns error when no key" do
    Aws::S3::Client.stub :new, Minitest::Mock.new do
      Aws::S3::Presigner.stub :new, @get_mock do
        get '/expanding_brain.json'
        assert_equal '{"errors":[{"detail":"Missing \'id\' field"}]}', @response.body
      end
    end
  end

  test "posts /expanding_brain.json" do
    ExpandingBrain.stub :new, @post_mock do
      post  '/expanding_brain.json', params: {brains: ["", "", "", ""]}
      assert_response :success
      assert_equal "application/json", @response.content_type
    end
  end

  test "returns key and presigned_url" do
    ExpandingBrain.stub :new, @post_mock do
      post  '/expanding_brain.json', params: {brains: ["", "", "", ""]}
      assert_equal '{"id":"something","url":"https://whatever/something"}', @response.body
    end
  end
end

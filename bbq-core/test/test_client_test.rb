require 'test_helper'
require 'bbq/core/test_client'

class TestClientTest < Minitest::Test

  def test_rack_test_to_env_headers_for_empty_hash
    test_client = Bbq::Core::TestClient::RackTest.new(:app)
    assert_equal({}, test_client.to_env_headers({}))
  end

  def test_rack_test_to_env_headers_for_content_type_or_content_length
    test_client = Bbq::Core::TestClient::RackTest.new(:app)
    result = test_client.to_env_headers({
      "content-type"   => "text/plain",
      "content-length" => "40"
    })
    assert_includes(result.keys, "CONTENT_TYPE")
    assert_includes(result.keys, "CONTENT_LENGTH")
  end

  def test_rack_test_to_env_headers_for_other_headers
    test_client = Bbq::Core::TestClient::RackTest.new(:app)
    result = test_client.to_env_headers({
      "silly-header" => "silly-value"
    })
    assert_includes(result.keys, "HTTP_SILLY_HEADER")
  end

end


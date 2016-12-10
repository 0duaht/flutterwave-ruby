require 'test_helper'

class NetworkManagerTest < Minitest::Test
  def setup
    @url = "/#{Faker::Lorem.word}"
    @body = {
      Faker::Lorem.word => Faker::Lorem.word,
      Faker::Lorem.word => Faker::Lorem.word
    }
    @response = {
      Faker::Lorem.word => Faker::Lorem.word,
      Faker::Lorem.word => Faker::Lorem.word
    }
  end

  def stub_flutterwave
    stub_request(:post, /#{Flutterwave::Utils::Constants::BASE_URL}/)
  end

  def test_that_it_returns_nil_when_network_connection_is_disabled
    stub_flutterwave.to_raise(SocketError)
    assert_nil Flutterwave::Utils::NetworkManager.post(@url, @body)
  end

  def test_that_it_returns_nil_when_response_does_not_match_json_specs
    stub_flutterwave.to_return(body: '')
    assert_nil Flutterwave::Utils::NetworkManager.post(@url, @body)
  end

  def test_that_it_makes_network_calls_successfully
    response_data = { 'data' => @response }
    stub_flutterwave.to_return(status: 200, body: response_data.to_json)

    assert_equal response_data,
                 Flutterwave::Utils::NetworkManager.post(@url, @body)
  end
end

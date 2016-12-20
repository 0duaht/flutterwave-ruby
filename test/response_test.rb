require 'test_helper'

class ResponseTest < Minitest::Test
  attr_reader :success_response, :failure_response

  def setup
    @success_response = {
      'data' => {
        'responseCode' => '00',
        'responseMessage' => Faker::Lorem.sentence
      },
      'status' => 'success'
    }

    @failure_response = {
      'data' => {
        'responseCode' => 'B02',
        'responseMessage' => Faker::Lorem.sentence
      },
      'status' => 'success'
    }
  end

  def test_for_successful_response
    assert Flutterwave::Response.new(success_response).successful?
  end

  def test_for_failed_response
    refute Flutterwave::Response.new(failure_response).successful?
  end

  def test_for_method_delegation
    assert_equal success_response['data']['responseMessage'],
                 Flutterwave::Response.new(
                   success_response).responseMessage
  end
end

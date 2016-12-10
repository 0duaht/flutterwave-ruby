require 'test_helper'

class ResponseTest < Minitest::Test
  include TestData
  def setup
    @ref = Faker::Crypto.md5[0, 7].upcase
    common_response = TestData::COMMON_RESPONSE.merge(
      'transactionReference' => @ref
    )
    @success_response = {
      'data' => common_response.merge('responseCode' => '00'),
      'status' => 'success'
    }

    @failure_response = {
      'data' => common_response.merge('responseCode' => 'B02'),
      'status' => 'success'
    }
  end

  def test_for_successful_response
    assert Flutterwave::Response.new(@success_response).successful?
  end

  def test_for_failed_response
    refute Flutterwave::Response.new(@failure_response).successful?
  end

  def test_for_method_delegation
    assert_equal @success_response['data']['transactionReference'],
                 Flutterwave::Response.new(
                   @success_response).transactionReference
  end
end

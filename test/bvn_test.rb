require 'test_helper'

class BVNTest < Minitest::Test
  def setup
    @bvn_number = Faker::Number.number(10)
    @otp_option = 'SMS'
    merchant_key = "tk_#{Faker::Crypto.md5[0, 10]}"
    api_key = "tk_#{Faker::Crypto.md5[0, 20]}"
    client = Flutterwave::Client.new(merchant_key, api_key)
    @bvn = Flutterwave::BVN.new(client)
    @common_response = TestData::COMMON_RESPONSE
  end

  def stub_flutterwave
    stub_request(
      :post, "#{Flutterwave::Utils::Constants::BASE_URL}"\
      "#{@url}"
    ).to_return(status: 200, body: @response_data.to_json)
  end

  def merge_response_with_success_status
    @response_data = {
      'data' => @common_response.merge(
        'responseCode' => '00'
      ),
      'status' => 'success'
    }
  end

  def test_verify
    @response_data = {
      'data' => @common_response.merge(
        'responseCode' => '00',
        'transactionReference' => Faker::Crypto.md5[0, 7].upcase
      ),
      'status' => 'success'
    }
    @url = Flutterwave::Utils::Constants::BVN[:verify_url]

    stub_flutterwave

    response = @bvn.verify(@otp_option, @bvn_number)
    assert response.successful?
  end

  def test_resend
    merge_response_with_success_status
    @url = Flutterwave::Utils::Constants::BVN[:resend_url]

    stub_flutterwave

    response = @bvn.resend(@otp_option, Faker::Crypto.md5[0, 7].upcase)
    assert response.successful?
  end

  def test_validate
    merge_response_with_success_status
    @url = Flutterwave::Utils::Constants::BVN[:validate_url]

    stub_flutterwave

    response = @bvn.validate(
      @otp_option, Faker::Crypto.md5[0, 7].upcase, @bvn_number)
    assert response.successful?
  end
end

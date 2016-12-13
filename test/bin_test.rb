require 'test_helper'

class BINTest < Minitest::Test
  include TestData
  def setup
    merchant_key = "tk_#{Faker::Crypto.md5[0, 10]}"
    api_key = "tk_#{Faker::Crypto.md5[0, 20]}"
    @client = Flutterwave::Client.new(merchant_key, api_key)
    @common_response = TestData::COMMON_RESPONSE
    @card_bin = Faker::Number.number(6)
  end

  def stub_flutterwave
    stub_request(
      :post, "#{Flutterwave::Utils::Constants::BASE_URL}"\
      "#{@url}"
    ).to_return(status: 200, body: @response_data.to_json)
  end

  def test_check
    @response_data = {
      'data' => @common_response.merge(
        'country' => Faker::Address.country,
        'cardBin' => @card_bin,
        'cardName' => Faker::Lorem.sentence,
        'nigeriancard' => Faker::Boolean.boolean,
        'transactionReference' => Faker::Crypto.md5[0, 7].upcase,
        'responseCode' => '00'
      ),
      'status' => 'success'
    }
    @url = Flutterwave::Utils::Constants::BIN[:check_url]

    stub_flutterwave

    response = @client.bin.check(@card_bin)
    assert response.successful?
  end
end

require 'test_helper'

class BINTest < Minitest::Test
  def setup
    merchant_key = "tk_#{Faker::Crypto.md5[0, 10]}"
    api_key = "tk_#{Faker::Crypto.md5[0, 20]}"
    @client = Flutterwave::Client.new(merchant_key, api_key)
    @card6 = Faker::Number.number(6)
  end

  def stub_flutterwave
    stub_request(
      :post, "#{Flutterwave::Utils::Constants::BASE_URL}"\
      "#{@url}"
    ).to_return(status: 200, body: @response_data.to_json)
  end

  def sample_check_body
    {
      card6: @card6
    }
  end

  def sample_check_response
    {
      'data' => {
        'country' => Faker::Address.country,
        'cardBin' => @card6,
        'cardName' => Faker::Lorem.sentence,
        'nigeriancard' => Faker::Boolean.boolean,
        'transactionReference' => Faker::Crypto.md5[0, 7].upcase,
        'responseCode' => '00'
      },
      'status' => 'success'
    }
  end

  def test_check_fails_without_card6_argument
    assert_raises Flutterwave::Utils::MissingKeyError do
      @client.bin.check({})
    end
  end

  def test_check
    @response_data = sample_check_response
    @url = Flutterwave::Utils::Constants::BIN[:check_url]

    stub_flutterwave

    response = @client.bin.check(sample_check_body)
    assert response.successful?
  end
end

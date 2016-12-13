require 'test_helper'

class IPTest < Minitest::Test
  def setup
    merchant_key = "tk_#{Faker::Crypto.md5[0, 10]}"
    api_key = "tk_#{Faker::Crypto.md5[0, 20]}"
    client = Flutterwave::Client.new(merchant_key, api_key)
    @ip = Flutterwave::IP.new(client)
    @ip_address = Faker::Internet.ip_v4_address
  end

  def stub_flutterwave
    stub_request(
      :post, "#{Flutterwave::Utils::Constants::BASE_URL}"\
      "#{@url}"
    ).to_return(status: 200, body: @response_data.to_json)
  end

  def sample_data
    {
      'data' => {
        'responsecode' => '00',
        'ipaddress' => @ip_address,
        'alpha2code' => Faker::Address.country_code,
        'alpha3code' => Faker::Address.country_code << 'X',
        'responsemessage' => Faker::Lorem.sentence,
        'country_name' => Faker::Address.country,
        'transactionreference' => "FLW#{Faker::Number.number(8)}"
      },
      'status' => 'success'
    }
  end

  def test_check
    @response_data = sample_data
    @url = Flutterwave::Utils::Constants::IP[:check_url]

    stub_flutterwave

    response = @ip.check(@ip_address)
    assert response.successful?
  end
end

require 'test_helper'

class PayTest < Minitest::Test
  def setup
    merchant_key = "tk_#{Faker::Crypto.md5[0, 10]}"
    api_key = "tk_#{Faker::Crypto.md5[0, 20]}"
    @client = Flutterwave::Client.new(merchant_key, api_key)
  end

  def stub_flutterwave
    stub_request(
      :post, "#{Flutterwave::Utils::Constants::BASE_URL}"\
      "#{@url}"
    ).to_return(status: 200, body: @response_data.to_json)
  end

  def sample_linked_accounts_response
    {
      'data' => {
        'responsecode' => '00',
        'linkedaccounts' => [
          {
            'accountnumber' => Faker::Number.number(10),
            'added' => Time.now.to_s,
            'status' => 'VALIDATED'
          },
          {
            'accountnumber' => Faker::Number.number(10),
            'added' => Time.now.to_s,
            'status' => 'VALIDATED'
          }
        ]
      },
      'status' => 'success'
    }
  end

  def sample_link_body
    {
      accountnumber: Faker::Number.number(10),
      country: Faker::Address.country_code
    }
  end

  def sample_link_response
    {
      'data' => {
        'responsecode' => '02',
        'responsemessage' => Faker::Lorem.sentence,
        'uniquereference' => "FLWT#{Faker::Number.number(8)}"
      },
      'status' => 'success'
    }
  end

  def sample_unlink_body
    {
      accountnumber: Faker::Number.number(10),
      country: Faker::Address.country_code
    }
  end

  def sample_unlink_response
    {
      'data' => {
        'responsecode' => '00',
        'responsemessage' => Faker::Lorem.sentence,
        'uniquereference' => Faker::Number.number(10)
      },
      'status' => 'success'
    }
  end

  def sample_status_body
    {
      uniquereference: Faker::Number.number(10),
      country: Faker::Address.country_code
    }
  end

  def sample_status_response
    {
      'data' => {
        'responsecode' => '00',
        'responsemessage' => Faker::Lorem.sentence,
        'uniquereference' => Faker::Number.number(10)
      },
      'status' => 'success'
    }
  end

  def sample_validate_body
    {
      otp: Faker::Number.number(6),
      relatedreference: "FLWT#{Faker::Number.number(8)}",
      otptype: 'PHONE_OTP'
    }
  end

  def sample_validate_response
    {
      'data' => {
        'responsecode' => '00',
        'responsemessage' => Faker::Lorem.sentence,
        'uniquereference' => "FLWT#{Faker::Number.number(8)}",
      },
      'status' => 'success'
    }
  end

  def sample_send_body
    {
      accounttoken: Faker::Number.number(6),
      destbankcode: Faker::Number.number(3),
      currency: 'NGN',
      transferamount: 1,
      narration: Faker::Lorem.sentence,
      recipientname: Faker::Name.name,
      sendername: Faker::Name.name,
      recipientaccount: Faker::Number.number(10),
      uniquereference: "FLWT#{Faker::Number.number(8)}",
      otptype: 'PHONE_OTP'
    }
  end

  def sample_send_response
    {
      'data' => {
        'responsecode' => '00',
        'responsemessage' => Faker::Lorem.sentence,
        'uniquereference' => Faker::Number.number(10)
      },
      'status' => 'success'
    }
  end

  def test_link
    @response_data = sample_link_response
    @url = Flutterwave::Utils::Constants::PAY[:link_url]

    stub_flutterwave

    response = @client.pay.link(sample_link_body)
    assert response.responsecode.eql? '02'
  end

  def test_validate
    @response_data = sample_validate_response
    @url = Flutterwave::Utils::Constants::PAY[:validate_url]

    stub_flutterwave

    response = @client.pay.validate(sample_validate_body)
    assert response.successful?
  end

  def test_send
    @response_data = sample_send_response
    @url = Flutterwave::Utils::Constants::PAY[:send_url]

    stub_flutterwave

    response = @client.pay.send(sample_send_body)
    assert response.successful?
  end

  def test_linked_accounts
    @response_data = sample_linked_accounts_response
    @url = Flutterwave::Utils::Constants::PAY[:linked_accounts_url]

    stub_flutterwave

    response = @client.pay.linked_accounts

    assert response.is_a? Array
    assert response.length == 2
    assert response.all? { |item| item.is_a? Flutterwave::LinkedAccount }
  end

  def test_unlink
    @response_data = sample_unlink_response
    @url = Flutterwave::Utils::Constants::PAY[:unlink_url]

    stub_flutterwave

    response = @client.pay.unlink(sample_unlink_body)
    assert response.successful?
  end

  def test_status
    @response_data = sample_status_response
    @url = Flutterwave::Utils::Constants::PAY[:status_url]

    stub_flutterwave

    response = @client.pay.status(sample_status_body)
    assert response.successful?
  end
end

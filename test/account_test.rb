require 'test_helper'

class AccountTest < Minitest::Test
  attr_reader :client

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

  def sample_initiate_recurrent_response
    {
      'data' => {
        'responsecode' => '00',
        'responsemessage' => Faker::Lorem.sentence,
        'transactionreference' => "FLW#{Faker::Number.number(8)}"
      },
      'status' => 'success'
    }
  end

  def sample_initiate_recurrent_body
    {
      accountNumber: Faker::Number.number(10)
    }
  end

  def sample_validate_response
    {
      'data' => {
        'responsecode' => '00',
        'responsemessage' => Faker::Lorem.sentence,
        'transactionreference' => Faker::Crypto.md5[0, 5]
      },
      'status' => 'success'
    }
  end

  def sample_validate_body
    {
      otp: Faker::Number.number(6),
      transactionreference: Faker::Crypto.md5[0, 5]
    }
  end

  def sample_validate_recurrent_response
    {
      'data' => {
        'accountToken' => Faker::Crypto.md5[0, 22],
        'responseCode' => '00',
        'responseDescription' => Faker::Lorem.sentence,
        'transactionreference' => Faker::Crypto.md5[0, 5]
      },
      'status' => 'success'
    }
  end

  def sample_validate_recurrent_body
    {
      accountNumber: Faker::Number.number(11),
      otp: Faker::Number.number(6),
      reference: Faker::Crypto.md5[0, 5],
      billingamount: Faker::Number.number(3),
      debitnarration: Faker::Lorem.sentence
    }
  end

  def sample_charge_recurrent_response
    {
      'data' => {
        'responseCode' => '00',
        'responseDescription' => Faker::Lorem.sentence,
        'transactionreference' => Faker::Crypto.md5[0, 5]
      },
      'status' => 'success'
    }
  end

  def sample_charge_recurrent_body
    {
      accountToken: Faker::Crypto.md5[0, 22],
      billingamount: Faker::Number.number(3),
      debitnarration: Faker::Lorem.sentence
    }
  end

  def sample_alt_validate_response
    {
      'data' => {
        'valid' => true,
        'responsecode' => '00',
        'responsemessage' => Faker::Lorem.sentence,
        'transactionreference' => Faker::Crypto.md5[0, 5]
      },
      'status' => 'success'
    }
  end

  def sample_alt_validate_body
    {
      otp: Faker::Number.number(6),
      phonenumber: Faker::Number.number(11)
    }
  end

  def sample_resend_response
    {
      'data' => {
        'responsecode' => '00',
        'responsemessage' => Faker::Lorem.sentence,
        'transactionreference' => Faker::Crypto.md5[0, 5]
      },
      'status' => 'success'
    }
  end

  def sample_resend_body
    {
      validateoption: 'SMS',
      transactionreference: Faker::Crypto.md5[0, 5]
    }
  end

  def sample_charge_response
    {
      'data' => {
        'responsecode' => '02',
        'responsemessage' => Faker::Lorem.sentence,
        'transactionreference' => Faker::Crypto.md5[0, 5]
      },
      'status' => 'success'
    }
  end

  def sample_charge_body
    {
      validateoption: 'SMS',
      accountnumber: Faker::Number.number(10),
      bankcode: Faker::Number.number(3),
      amount: 1,
      currency: 'NGN',
      firstname: Faker::Name.first_name,
      lastname: Faker::Name.last_name,
      email: Faker::Internet.email,
      transactionreference: Faker::Crypto.md5[0, 5],
      narration: Faker::Lorem.sentence
    }
  end

  def test_charge
    @response_data = sample_charge_response
    @url = Flutterwave::Utils::Constants::ACCOUNT[:charge_url]

    stub_flutterwave

    response = client.account.charge(sample_charge_body)
    assert response.responsecode.eql? '02'
  end

  def test_resend
    @response_data = sample_resend_response
    @url = Flutterwave::Utils::Constants::ACCOUNT[:resend_url]

    stub_flutterwave

    response = client.account.resend(sample_resend_body)
    assert response.successful?
  end

  def test_validate
    @response_data = sample_validate_response
    @url = Flutterwave::Utils::Constants::ACCOUNT[:validate_url]

    stub_flutterwave

    response = client.account.validate(sample_validate_body)
    assert response.successful?
  end

  def test_alt_validate
    @response_data = sample_alt_validate_response
    @url = Flutterwave::Utils::Constants::ACCOUNT[:alt_validate_url]

    stub_flutterwave

    response = client.account.alt_validate(sample_alt_validate_body)
    assert response.successful?
  end

  def test_initiate_recurrent
    @response_data = sample_initiate_recurrent_response
    @url = Flutterwave::Utils::Constants::ACCOUNT[:initiate_recurrent_url]

    stub_flutterwave

    response = client.account.initiate_recurrent(sample_initiate_recurrent_body)
    assert response.successful?
  end

  def test_validate_recurrent
    @response_data = sample_validate_recurrent_response
    @url = Flutterwave::Utils::Constants::ACCOUNT[:validate_recurrent_url]

    stub_flutterwave

    response = client.account.validate_recurrent(
      sample_validate_recurrent_body
    )
    assert response.successful?
  end

  def test_charge_recurrent
    @response_data = sample_charge_recurrent_response
    @url = Flutterwave::Utils::Constants::ACCOUNT[:charge_recurrent_url]

    stub_flutterwave

    response = client.account.charge_recurrent(
      sample_charge_recurrent_body
    )
    assert response.successful?
  end
end

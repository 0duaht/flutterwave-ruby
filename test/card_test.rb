require 'test_helper'

class CardTest < Minitest::Test
  def setup
    merchant_key = "tk_#{Faker::Crypto.md5[0, 10]}"
    api_key = "tk_#{Faker::Crypto.md5[0, 20]}"
    @client = Flutterwave::Client.new(merchant_key, api_key)
    @ip_address = Faker::Internet.ip_v4_address
  end

  def stub_flutterwave
    stub_request(
      :post, "#{Flutterwave::Utils::Constants::BASE_URL}"\
      "#{@url}"
    ).to_return(status: 200, body: @response_data.to_json)
  end

  def sample_charge_response
    {
      'data' => {
        'responsecode' => '00',
        'avsresponsemessage' => 'Address Verification is Unsupported.',
        'avsresponsecode' => 'Unsupported',
        'responsemessage' => 'Approved',
        'otptransactionidentifier' => nil,
        'transactionreference' => "FLW#{Faker::Number.number(8)}",
        'responsehtml' => nil,
        'responsetoken' => Faker::Crypto.md5[0, 19].to_s
      },
      'status' => 'success'
    }
  end

  def sample_charge_body
    {
      authmodel: 'NOAUTH',
      cardno: Faker::Number.number(16),
      cvv: Faker::Number.number(3),
      expirymonth: Faker::Number.number(2),
      expiryyear: Faker::Number.number(2),
      amount: 1,
      currency: 'NGN',
      custid: 1,
      narration: 'Sample debit'
    }
  end

  def sample_recurrent_charge_body
    {
      chargetoken: Faker::Crypto.md5[0, 19].to_s,
      amount: 1,
      currency: 'NGN',
      custid: 1,
      narration: 'Sample debit'
    }
  end

  def sample_validate_enquiry_response
    {
      'data' => {
        'responsecode' => '00',
        'balance' => '43.79',
        'responsemessage' => 'Successful',
        'cardType' => 'MasterCard',
        'chargetoken' => nil,
        'transactionref' => "TST/FLW#{Faker::Number.number(8)}",
        'otpref' => nil
      },
      'status' => 'success'
    }
  end

  def sample_validate_enquiry_body
    {
      otp: Faker::Number.number(6),
      trxreference: "FLW#{Faker::Number.number(8)}",
      otptransactionidentifier: "FLW#{Faker::Number.number(8)}"
    }
  end

  def sample_enquiry_response
    {
      'data' => {
        'responsecode' => '02',
        'balance' => nil,
        'avsresponsecode' => nil,
        'responsemessage' => 'Press the white button on your GTB token and type the transaction code generated.',
        'cardType' => nil,
        'chargetoken' => nil,
        'transactionref' => "FLW#{Faker::Number.number(8)}",
        'otpref' => "TST/FLW#{Faker::Number.number(8)}"
      },
      'status' => 'success'
    }
  end


  def sample_enquiry_body
    {
      cardno: Faker::Number.number(16),
      cvv: Faker::Number.number(3),
      expirymonth: Faker::Number.number(2),
      expiryyear: Faker::Number.number(2),
      pin: Faker::Number.number(4),
      trxreference: "FLW#{Faker::Number.number(8)}"
    }
  end

  def sample_refund_or_void_response
    {
      'data' => {
        'responsecode' => '00',
        'avsresponsemessage' => nil,
        'avsresponsecode' => nil,
        'responsemessage' => 'Approved',
        'otptransactionidentifier' => nil,
        'transactionreference' => "FLW#{Faker::Number.number(8)}",
        'responsehtml' => nil,
        'responsetoken' => nil
      },
      'status' => 'success'
    }
  end

  def sample_refund_or_void_body
    {
      amount: '50',
      currency: 'NGN',
      trxauthorizeid: Faker::Number.number(5).to_s,
      trxreference: "FLW#{Faker::Number.number(8)}"
    }
  end

  def sample_capture_response
    {
      'data' => {
        'responsecode' => '00',
        'avsresponsemessage' => nil,
        'avsresponsecode' => nil,
        'authorizeId' => '',
        'responsemessage' => 'Approved',
        'otptransactionidentifier' => nil,
        'transactionreference' => "FLW#{Faker::Number.number(8)}",
        'responsehtml' => nil,
        'responsetoken' => nil
      },
      'status' => 'success'
    }
  end

  def sample_capture_body
    {
      amount: '50',
      currency: 'NGN',
      trxauthorizeid: Faker::Number.number(5).to_s,
      trxreference: "FLW#{Faker::Number.number(8)}",
      chargetoken: Faker::Crypto.md5[0, 19].to_s
    }
  end

  def sample_preauthorize_response
    {
      'data' => {
        'responsecode' => '00',
        'avsresponsemessage' => nil,
        'avsresponsecode' => nil,
        'responsemessage' => Faker::Lorem.sentence,
        'otptransactionidentifier' => nil,
        'transactionreference' => "FLW#{Faker::Number.number(8)}",
        'responsetoken' => nil,
        'responsehtml' => nil
      },
      'status' => 'success'
    }
  end

  def sample_preauthorize_body
    {
      amount: '50',
      currency: 'NGN',
      chargetoken: Faker::Crypto.md5[0, 19].to_s
    }
  end

  def sample_tokenize_response
    {
      'data' => {
        'responsecode' => '00',
        'avsresponsemessage' => nil,
        'avsresponsecode' => nil,
        'authorizeId' => Faker::Number.number(5).to_s,
        'responsemessage' => 'Approved',
        'otptransactionidentifier' => nil,
        'transactionreference' => nil,
        'responsetoken' => Faker::Crypto.md5[0, 19].to_s
      },
      'status' => 'success'
    }
  end

  def sample_tokenize_body
    {
      validateoption: 'SMS',
      authmodel: 'NOAUTH',
      cardno: Faker::Number.number(16).to_s,
      cvv: Faker::Number.number(3).to_s,
      expirymonth: Faker::Number.number(2).to_s,
      expiryyear: Faker::Number.number(2).to_s
    }
  end

  def test_tokenize
    @response_data = sample_tokenize_response
    @url = Flutterwave::Utils::Constants::CARD[:tokenize_url]

    stub_flutterwave

    response = @client.card.tokenize(sample_tokenize_body)
    assert response.successful?
  end

  def test_preauthorize
    @response_data = sample_preauthorize_response
    @url = Flutterwave::Utils::Constants::CARD[:preauthorize_url]

    stub_flutterwave

    response = @client.card.preauthorize(sample_preauthorize_body)
    assert response.successful?
  end

  def test_capture
    @response_data = sample_capture_response
    @url = Flutterwave::Utils::Constants::CARD[:capture_url]

    stub_flutterwave

    response = @client.card.capture(sample_capture_body)
    assert response.successful?
  end

  def test_refund
    @response_data = sample_refund_or_void_response
    @url = Flutterwave::Utils::Constants::CARD[:refund_url]

    stub_flutterwave

    response = @client.card.refund(sample_refund_or_void_body)
    assert response.successful?
  end

  def test_void
    @response_data = sample_refund_or_void_response
    @url = Flutterwave::Utils::Constants::CARD[:void_url]

    stub_flutterwave

    response = @client.card.void(sample_refund_or_void_body)
    assert response.successful?
  end

  def test_enquiry
    @response_data = sample_enquiry_response
    @url = Flutterwave::Utils::Constants::CARD[:enquiry_url]

    stub_flutterwave

    response = @client.card.enquiry(sample_enquiry_body)
    assert response.responsecode.eql? '02'
  end

  def test_validate_enquiry
    @response_data = sample_validate_enquiry_response
    @url = Flutterwave::Utils::Constants::CARD[:validate_enquiry_url]

    stub_flutterwave

    response = @client.card.validate_enquiry(sample_validate_enquiry_body)
    assert response.successful?
  end

  def test_charge
    @response_data = sample_charge_response
    @url = Flutterwave::Utils::Constants::CARD[:charge_url]

    stub_flutterwave

    response = @client.card.charge(sample_charge_body)
    assert response.successful?
  end

  def test_recurrent_charge
    @response_data = sample_charge_response
    @url = Flutterwave::Utils::Constants::CARD[:charge_url]

    stub_flutterwave

    response = @client.card.recurrent_charge(sample_recurrent_charge_body)
    assert response.successful?
  end
end

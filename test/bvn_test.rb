require 'test_helper'

class BVNTest < Minitest::Test
  include FlutterWaveTestHelper

  attr_reader :client, :bvn_number, :otpoption, :response_data, :url

  def setup
    @bvn_number = Faker::Number.number(10)
    @otpoption = 'SMS'
    merchant_key = "tk_#{Faker::Crypto.md5[0, 10]}"
    api_key = "tk_#{Faker::Crypto.md5[0, 20]}"
    @client = Flutterwave::Client.new(merchant_key, api_key)
  end

  def set_response
    @response_data = {
      'data' => {
        'responseCode' => '00',
        'responseMessage' => Faker::Lorem.sentence,
        'transactionReference' => Faker::Crypto.md5[0, 7].upcase
      },
      'status' => 'success'
    }
  end

  def sample_verify_body
    {
      otpoption: otpoption,
      bvn: bvn_number
    }
  end

  def sample_verify_response
    {
      'data' => {
        'responseCode' => '00',
        'responseMessage' => Faker::Lorem.sentence,
        'transactionReference' => Faker::Crypto.md5[0, 7].upcase
      },
      'status' => 'success'
    }
  end

  def sample_resend_or_validate_response
    {
      'data' => {
        'responseCode' => '00',
        'responseMessage' => Faker::Lorem.sentence,
      },
      'status' => 'success'
    }
  end

  def sample_resend_body
    {
      validateoption: otpoption,
      transactionreference: Faker::Crypto.md5[0, 7].upcase
    }
  end

  def sample_validate_body
    {
      otp: otpoption,
      transactionreference: Faker::Crypto.md5[0, 7].upcase,
      bvn: bvn_number
    }
  end

  def test_verify
    @response_data = sample_verify_response
    @url = Flutterwave::Utils::Constants::BVN[:verify_url]

    stub_flutterwave

    response = client.bvn.verify(sample_verify_body)
    assert response.successful?
  end

  def test_resend
    @response_data = sample_resend_or_validate_response
    @url = Flutterwave::Utils::Constants::BVN[:resend_url]

    stub_flutterwave

    response = @client.bvn.resend(sample_resend_body)
    assert response.successful?
  end

  def test_validate
    @response_data = sample_resend_or_validate_response
    @url = Flutterwave::Utils::Constants::BVN[:validate_url]

    stub_flutterwave

    response = @client.bvn.validate(sample_validate_body)
    assert response.successful?
  end
end

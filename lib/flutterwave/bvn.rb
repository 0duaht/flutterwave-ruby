module Flutterwave
  class BVN
    include Flutterwave::Helpers
    attr_accessor :client, :options

    def initialize(client)
      @client = client
    end

    # https://www.flutterwave.com/documentation/compliance/ - Verify (request a user enter their BVN for verification)
    def verify(options = {})
      @options = options

      request_params = {
        otpoption: encrypt(:otpoption),
        bvn: encrypt(:bvn),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::BVN[:verify_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    # https://www.flutterwave.com/documentation/compliance/ - Resend OTP
    def resend(options = {})
      @options = options

      request_params = {
        validateoption: encrypt(:validateoption),
        transactionreference: encrypt(:transactionreference),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::BVN[:resend_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    # https://www.flutterwave.com/documentation/compliance/ - Validate (This is used to validate the OTP entered by the user)
    def validate(options = {})
      @options = options

      request_params = {
        otp: encrypt(:otp),
        transactionreference: encrypt(:transactionreference),
        bvn: encrypt(:bvn),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::BVN[:validate_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def encrypt(key)
      plain_text = options[key].to_s
      raise Flutterwave::Utils::MissingKeyError.new(
        "#{key.capitalize} key required!"
      ) if plain_text.empty?

      encrypt_data(plain_text, client.api_key)
    end
  end
end

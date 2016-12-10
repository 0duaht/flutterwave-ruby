require 'flutterwave/utils/network_manager'
require 'flutterwave/utils/encryption_manager'
require 'flutterwave/utils/constants'
require 'flutterwave/response'

module Flutterwave
  class BVN
    attr_accessor :client

    def initialize(client)
      @client = client
    end

    def verify(otpoption, bvn)
      response = post(
        Flutterwave::Utils::Constants::BVN[:verify_url],
        otpoption: encrypt(otpoption),
        bvn: encrypt(bvn),
        merchantid: client.merchant_key
      )

      Flutterwave::Response.new(response)
    end

    def resend(otpoption, transaction_ref)
      response = post(
        Flutterwave::Utils::Constants::BVN[:resend_url],
        validateoption: encrypt(otpoption),
        transactionreference: encrypt(transaction_ref),
        merchantid: client.merchant_key
      )

      Flutterwave::Response.new(response)
    end

    def validate(otp, transaction_ref, bvn)
      response = post(
        Flutterwave::Utils::Constants::BVN[:validate_url],
        otp: encrypt(otp),
        transactionreference: encrypt(transaction_ref),
        bvn: encrypt(bvn),
        merchantid: client.merchant_key
      )

      Flutterwave::Response.new(response)
    end

    def post(url, data)
      Flutterwave::Utils::NetworkManager.post(url, data)
    end

    def encrypt(plain_text)
      Flutterwave::Utils::EncryptionManager.encrypt(plain_text, client.api_key)
    end
  end
end

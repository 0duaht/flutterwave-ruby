require 'flutterwave/response'

module Flutterwave
  class Account
    include Flutterwave::Helpers
    attr_accessor :client, :options

    def initialize(client)
      @client = client
    end

    # https://www.flutterwave.com/documentation/alternative-payments-recurrent/#initiate
    def initiate_recurrent(options = {})
      @options = options

      request_params = {
        accountNumber: encrypt(:accountNumber),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::ACCOUNT[:initiate_recurrent_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    # https://www.flutterwave.com/documentation/alternative-payments-recurrent/#validate
    def validate_recurrent(options = {})
      @options = options

      request_params = {
        accountNumber: encrypt(:accountNumber),
        otp: encrypt(:otp),
        reference: encrypt(:reference),
        billingamount: encrypt(:billingamount),
        debitnarration: encrypt(:debitnarration),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::ACCOUNT[:validate_recurrent_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    # https://www.flutterwave.com/documentation/alternative-payments-recurrent/#initiate
    def charge_recurrent(options = {})
      @options = options

      request_params = {
        accountToken: encrypt(:accountToken),
        billingamount: encrypt(:billingamount),
        debitnarration: encrypt(:debitnarration),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::ACCOUNT[:charge_recurrent_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    # https://www.flutterwave.com/documentation/alternative-payments/#charge-ii
    def charge(options = {})
      @options = options
      options[:country] ||= 'NG'

      request_params = {
        validateoption: encrypt(:validateoption),
        accountnumber: encrypt(:accountnumber),
        bankcode: encrypt(:bankcode),
        amount: encrypt(:amount),
        currency: encrypt(:currency),
        firstname: encrypt(:firstname),
        lastname: encrypt(:lastname),
        email: encrypt(:email),
        narration: encrypt(:narration),
        transactionreference: encrypt(:transactionreference),
        merchantid: client.merchant_key
      }

      request_params[:passcode] = encrypt(:passcode) if options[:passcode]

      response = post(
        Flutterwave::Utils::Constants::ACCOUNT[:charge_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    # https://www.flutterwave.com/documentation/alternative-payments/#resend-otp
    def resend(options = {})
      @options = options

      request_params = {
        validateoption: encrypt(:validateoption),
        transactionreference: encrypt(:transactionreference),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::ACCOUNT[:resend_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    # https://www.flutterwave.com/documentation/alternative-payments/#validate-ii
    def validate(options = {})
      @options = options

      request_params = {
        otp: encrypt(:otp),
        transactionreference: encrypt(:transactionreference),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::ACCOUNT[:validate_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    # https://www.flutterwave.com/documentation/alternative-payments/#validate-ii-alt
    def alt_validate(options = {})
      @options = options

      request_params = {
        otp: encrypt(:otp),
        phonenumber: encrypt(:phonenumber),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::ACCOUNT[:alt_validate_url],
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

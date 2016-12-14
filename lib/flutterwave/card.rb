require 'flutterwave/utils/helpers'
require 'flutterwave/utils/missing_key_error'
require 'flutterwave/response'

module Flutterwave
  class Card
    include Flutterwave::Helpers
    attr_accessor :client, :options

    def initialize(client)
      @client = client
    end

    def tokenize(options)
      @options = options
      options[:country] ||= 'NG'

      request_params = {
        validateoption: encrypt(:validateoption),
        authmodel: encrypt(:authmodel),
        cardno: encrypt(:cardno),
        cvv: encrypt(:cvv),
        country: encrypt(:country),
        expirymonth: encrypt(:expirymonth),
        expiryyear: encrypt(:expiryyear),
        merchantid: client.merchant_key
      }

      request_params = request_params.merge(
        bvn: encrypt(:bvn)
      ) if options[:authmodel] == 'BVN'

      response = post(
        Flutterwave::Utils::Constants::CARD[:tokenize_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def preauthorize(options)
      @options = options
      options[:country] ||= 'NG'

      request_params = {
        amount: encrypt(:amount),
        currency: encrypt(:currency),
        chargetoken: encrypt(:chargetoken),
        country: encrypt(:country),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::CARD[:preauthorize_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def capture(options)
      @options = options
      options[:country] ||= 'NG'

      request_params = {
        amount: encrypt(:amount),
        currency: encrypt(:currency),
        country: encrypt(:country),
        trxreference: encrypt(:trxreference),
        trxauthorizeid: encrypt(:trxauthorizeid),
        chargetoken: encrypt(:chargetoken),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::CARD[:capture_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def refund(options)
      @options = options
      options[:country] ||= 'NG'

      request_params = {
        amount: encrypt(:amount),
        currency: encrypt(:currency),
        country: encrypt(:country),
        trxreference: encrypt(:trxreference),
        trxauthorizeid: encrypt(:trxauthorizeid),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::CARD[:refund_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def void(options)
      @options = options
      options[:country] ||= 'NG'

      request_params = {
        amount: encrypt(:amount),
        currency: encrypt(:currency),
        country: encrypt(:country),
        trxreference: encrypt(:trxreference),
        trxauthorizeid: encrypt(:trxauthorizeid),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::CARD[:void_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def enquiry(options)
      @options = options

      request_params = {
        cardno: encrypt(:cardno),
        cvv: encrypt(:cvv),
        expirymonth: encrypt(:expirymonth),
        expiryyear: encrypt(:expiryyear),
        pin: encrypt(:pin),
        trxreference: encrypt(:trxreference),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::CARD[:enquiry_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def validate_enquiry(options)
      @options = options

      request_params = {
        otp: encrypt(:otp),
        otptransactionidentifier: encrypt(:otptransactionidentifier),
        trxreference: encrypt(:trxreference),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::CARD[:validate_enquiry_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def charge(options)
      @options = options
      options[:country] ||= 'NG'

      request_params = {
        amount: encrypt(:amount),
        authmodel: encrypt(:authmodel),
        cardno: encrypt(:cardno),
        currency: encrypt(:currency),
        custid: encrypt(:custid),
        country: encrypt(:country),
        cvv: encrypt(:cvv),
        expirymonth: encrypt(:expirymonth),
        expiryyear: encrypt(:expiryyear),
        narration: encrypt(:narration),
        merchantid: client.merchant_key
      }

      request_params = request_params.merge(
        pin: encrypt(:pin)
      ) if options[:authmodel] == 'PIN'

      request_params = request_params.merge(
        bvn: encrypt(:bvn)
      ) if options[:authmodel] == 'BVN'

      request_params = request_params.merge(
        responseurl: encrypt(:responseurl)
      ) if options[:authmodel] == 'VBVSECURECODE'

      request_params = request_params.merge(
        cardtype: encrypt(:cardtype)
      ) if options[:cardtype]

      response = post(
        Flutterwave::Utils::Constants::CARD[:charge_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def validate_charge(options)
      @options = options

      request_params = {
        otp: encrypt(:otp),
        otptransactionidentifier: encrypt(:otptransactionidentifier),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::CARD[:validate_charge_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def recurrent_charge(options)
      @options = options
      options[:country] ||= 'NG'

      request_params = {
        amount: encrypt(:amount),
        currency: encrypt(:currency),
        custid: encrypt(:custid),
        country: encrypt(:country),
        narration: encrypt(:narration),
        chargetoken: encrypt(:chargetoken),
        merchantid: client.merchant_key
      }

      request_params = request_params.merge(
        cardtype: encrypt(:cardtype)
      ) if options[:cardtype]

      response = post(
        Flutterwave::Utils::Constants::CARD[:charge_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    def verify(options)
      @options = options

      request_params = {
        trxreference: encrypt(:trxreference),
        merchantid: client.merchant_key
      }

      response = post(
        Flutterwave::Utils::Constants::CARD[:verify_url],
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

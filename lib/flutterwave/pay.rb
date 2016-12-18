require 'flutterwave/response'
require 'time'

module Flutterwave
  class Pay
    include Flutterwave::Helpers
    attr_accessor :client, :options

    def initialize(client)
      @client = client
    end

    def link(options = {})
      @options = options
      options[:country] ||= 'NG'

      response = post(
        Flutterwave::Utils::Constants::PAY[:link_url],
        merchantid: client.merchant_key,
        accountnumber: encrypt(:accountnumber),
        country: encrypt(:country)
      )

      Flutterwave::Response.new(response)
    end

    def validate(options = {})
      @options = options
      options[:country] ||= 'NG'

      response = post(
        Flutterwave::Utils::Constants::PAY[:validate_url],
        merchantid: client.merchant_key,
        otp: encrypt(:otp),
        relatedreference: encrypt(:relatedreference),
        otptype: encrypt(:otptype),
        country: encrypt(:country)
      )

      Flutterwave::Response.new(response)
    end

    def send(options = {})
      @options = options
      options[:country] ||= 'NG'

      response = post(
        Flutterwave::Utils::Constants::PAY[:send_url],
        merchantid: client.merchant_key,
        accounttoken: encrypt(:accounttoken),
        destbankcode: encrypt(:destbankcode),
        currency: encrypt(:currency),
        country: encrypt(:country),
        transferamount: encrypt(:transferamount),
        uniquereference: encrypt(:uniquereference),
        narration: encrypt(:narration),
        recipientname: encrypt(:recipientname),
        sendername: encrypt(:sendername),
        recipientaccount: encrypt(:recipientaccount)
      )

      Flutterwave::Response.new(response)
    end

    def linked_accounts(options = {})
      @options = options
      options[:country] ||= 'NG'

      response = post(
        Flutterwave::Utils::Constants::PAY[:linked_accounts_url],
        merchantid: client.merchant_key,
        country: encrypt(:country)
      )

      Flutterwave::Response.new(response)
    end

    def unlink(options = {})
      @options = options
      options[:country] ||= 'NG'

      response = post(
        Flutterwave::Utils::Constants::PAY[:unlink_url],
        merchantid: client.merchant_key,
        accountnumber: encrypt(:accountnumber),
        country: encrypt(:country)
      )

      Flutterwave::Response.new(response)
    end

    def status(options = {})
      @options = options
      options[:country] ||= 'NG'

      response = post(
        Flutterwave::Utils::Constants::PAY[:status_url],
        merchantid: client.merchant_key,
        uniquereference: encrypt(:uniquereference),
        country: encrypt(:country)
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

require 'flutterwave/utils/helpers'
require 'flutterwave/utils/missing_key_error'
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

      all_linked_accounts = response['data']['linkedaccounts']
      all_linked_accounts.each.inject([]) do |list, linked_account|
        list << LinkedAccount.new(
          linked_account['accountnumber'],
          linked_account['added'],
          linked_account['status']
        )
      end
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

  class LinkedAccount
    attr_accessor :accountnumber, :added, :status

    def initialize(accountnumber, added, status)
      @accountnumber = accountnumber
      @added = Time.parse(added)
      @status = status
    end
  end
end

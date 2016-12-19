module Flutterwave
  class ACH
    include Flutterwave::Helpers
    attr_accessor :client, :options

    def initialize(client)
      @client = client
    end

    # https://www.flutterwave.com/documentation/ach-payments/#get-institutions
    def list
      response = post(
        Flutterwave::Utils::Constants::ACH[:list_url],
        merchantid: client.merchant_key
      )

      Flutterwave::Response.new(response)
    end

    # https://www.flutterwave.com/documentation/ach-payments/#get-institution-by-id
    def find_by_id(options = {})
      @options = options

      response = post(
        Flutterwave::Utils::Constants::ACH[:id_url],
        institutionid: encrypt(:id),
        merchantid: client.merchant_key
      )

      Flutterwave::Response.new(response)
    end

    # https://www.flutterwave.com/documentation/ach-payments/#add-user
    def add_user(options = {})
      @options = options

      request_params = {
        username: encrypt(:username),
        password: encrypt(:password),
        email: encrypt(:email),
        institution: encrypt(:institution),
        merchantid: client.merchant_key
      }

      request_params[:pin] = encrypt(:pin) if options[:pin]

      response = post(
        Flutterwave::Utils::Constants::ACH[:add_user_url],
        request_params
      )

      Flutterwave::Response.new(response)
    end

    # https://www.flutterwave.com/documentation/ach-payments/#charge
    def charge(options = {})
      @options = options

      response = post(
        Flutterwave::Utils::Constants::ACH[:charge_url],
        publictoken: encrypt(:publictoken),
        accountid: encrypt(:accountid),
        custid: encrypt(:custid),
        narration: encrypt(:narration),
        trxreference: encrypt(:trxreference),
        amount: encrypt(:amount),
        currency: encrypt(:currency),
        merchantid: client.merchant_key
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

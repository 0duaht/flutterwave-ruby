module Flutterwave
  class BIN
    include Flutterwave::Helpers
    attr_accessor :client, :options

    def initialize(client)
      @client = client
    end

    # https://www.flutterwave.com/documentation/compliance/ - Verify Card BIN API
    def check(options = {})
      @options = options

      request_params = {
        card6: encrypt(:card6)
      }

      response = post(
        Flutterwave::Utils::Constants::BIN[:check_url],
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

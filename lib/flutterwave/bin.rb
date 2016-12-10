require 'flutterwave/utils/helpers'

module Flutterwave
  class BIN
    attr_accessor :client

    def initialize(client)
      @client = client
    end

    def check(cardbin)
      response = post(
        Flutterwave::Utils::Constants::BIN[:check_url],
        card6: cardbin
      )

      Flutterwave::Response.new(response)
    end

    def post(url, data)
      Flutterwave::Utils::NetworkManager.post(url, data)
    end
  end
end

require 'flutterwave/utils/helpers'

module Flutterwave
  class IP
    attr_accessor :client

    def initialize(client)
      @client = client
    end

    def check(ip)
      response = post(
        Flutterwave::Utils::Constants::IP[:check_url],
        ip: ip
      )

      Flutterwave::Response.new(response)
    end

    def post(url, data)
      Flutterwave::Utils::NetworkManager.post(url, data)
    end
  end
end

module Flutterwave
  class IP
    attr_accessor :client

    def initialize(client)
      @client = client
    end

    def check(options = {})
      raise Flutterwave::Utils::MissingKeyError.new(
        'IP key required!'
      ) unless options[:ip]

      response = post(
        Flutterwave::Utils::Constants::IP[:check_url],
        ip: options[:ip]
      )

      Flutterwave::Response.new(response)
    end

    def post(url, data)
      Flutterwave::Utils::NetworkManager.post(url, data)
    end
  end
end

require 'net/http'
require 'uri'
require 'json'
require 'flutterwave/utils/constants'

module Flutterwave
  module Utils
    module NetworkManager
      BASE_URL = Flutterwave::Utils::Constants::BASE_URL

      def self.post(url, body)
        uri = URI.parse("#{BASE_URL}#{url}")
        request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
        request.body = body.to_json
        response = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(request)
        end

        JSON.parse(response.body)
      rescue SocketError, TypeError, EOFError, JSON::ParserError
        return nil
      end
    end
  end
end

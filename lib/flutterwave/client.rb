require 'flutterwave/bvn'
require 'flutterwave/bin'
require 'flutterwave/ip'

module Flutterwave
  class Client
    attr_accessor :merchant_key, :api_key, :bvn, :bin, :ip

    def initialize(merchant_key, api_key)
      @merchant_key = merchant_key
      @api_key = api_key

      @bvn = Flutterwave::BVN.new(self)
      @bin = Flutterwave::BIN.new(self)
      @ip = Flutterwave::IP.new(self)
    end
  end
end

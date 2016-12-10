require 'flutterwave/bvn'
require 'flutterwave/bin'

module Flutterwave
  class Client
    attr_accessor :merchant_key, :api_key, :bvn, :bin

    def initialize(merchant_key, api_key)
      @merchant_key = merchant_key
      @api_key = api_key

      @bvn = Flutterwave::BVN.new(self)
      @bin = Flutterwave::BIN.new(self)
    end
  end
end

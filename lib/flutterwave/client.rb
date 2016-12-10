require 'flutterwave/bvn'

module Flutterwave
  class Client
    attr_accessor :merchant_key, :api_key, :bvn

    def initialize(merchant_key, api_key)
      @merchant_key = merchant_key
      @api_key = api_key

      @bvn = Flutterwave::BVN.new(self)
    end
  end
end

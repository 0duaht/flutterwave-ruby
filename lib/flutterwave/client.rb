require 'flutterwave/utils/helpers'
require 'flutterwave/utils/missing_key_error'
require 'flutterwave/bvn'
require 'flutterwave/bin'
require 'flutterwave/ip'
require 'flutterwave/bank'
require 'flutterwave/card'
require 'flutterwave/account'
require 'flutterwave/ach'
require 'flutterwave/pay'

module Flutterwave
  class Client
    attr_accessor :merchant_key, :api_key, :bvn, :bin, :ip, :bank,
                  :card, :account, :ach, :pay

    def initialize(merchant_key, api_key)
      @merchant_key = merchant_key
      @api_key = api_key

      @bvn = Flutterwave::BVN.new(self)
      @bin = Flutterwave::BIN.new(self)
      @ip = Flutterwave::IP.new(self)
      @bank = Flutterwave::BankAPI.new(self)
      @card = Flutterwave::Card.new(self)
      @account = Flutterwave::Account.new(self)
      @ach = Flutterwave::ACH.new(self)
      @pay = Flutterwave::Pay.new(self)
    end
  end
end

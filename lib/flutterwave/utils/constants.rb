module Flutterwave
  module Utils
    module Constants
      BASE_URL = 'http://staging1flutterwave.co:8080'.freeze
      KEY = 'tk_0f86a4ef436f76faab1d3'.freeze

      BVN = {
        verify_url: '/pwc/rest/bvn/verify/',
        resend_url: '/pwc/rest/bvn/resendotp/',
        validate_url: '/pwc/rest/bvn/validate/'
      }.freeze

      BIN = {
        check_url: '/pwc/rest/fw/check/'
      }.freeze
    end
  end
end

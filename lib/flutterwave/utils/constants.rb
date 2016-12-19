module Flutterwave
  module Utils
    module Constants
      BASE_URL = ENV['FLUTTERWAVE_BASE_URL'] ||
                 'http://staging1flutterwave.co:8080'.freeze
      KEY = 'tk_0f86a4ef436f76faab1d3'.freeze

      BANK = {
        list_url: '/pwc/rest/fw/banks'
      }.freeze

      ACH = {
        list_url: '/pwc/rest/card/mvva/institutions',
        id_url: '/pwc/rest/card/mvva/institutions/id',
        add_user_url: '/pwc/rest/card/mvva/adduser',
        charge_url: '/pwc/rest/card/mvva/chargeach'
      }.freeze

      PAY = {
        link_url: '/pwc/rest/pay/linkaccount',
        validate_url: '/pwc/rest/pay/linkaccount/validate',
        linked_accounts_url: '/pwc/rest/pay/getlinkedaccounts',
        send_url: '/pwc/rest/pay/send',
        unlink_url: '/pwc/rest/pay/unlinkaccount',
        status_url: '/pwc/rest/pay/status'
      }.freeze

      BVN = {
        verify_url: '/pwc/rest/bvn/verify/',
        resend_url: '/pwc/rest/bvn/resendotp/',
        validate_url: '/pwc/rest/bvn/validate/'
      }.freeze

      BIN = {
        check_url: '/pwc/rest/fw/check/'
      }.freeze

      IP = {
        check_url: '/pwc/rest/fw/ipcheck'
      }.freeze

      CARD = {
        tokenize_url: '/pwc/rest/card/mvva/tokenize',
        preauthorize_url: '/pwc/rest/card/mvva/preauthorize',
        capture_url: '/pwc/rest/card/mvva/capture',
        refund_url: '/pwc/rest/card/mvva/refund',
        void_url: '/pwc/rest/card/mvva/void',
        enquiry_url: '/pwc/rest/card/mvva/cardenquiry',
        validate_enquiry_url: '/pwc/rest/card/mvva/cardenquiry/validate',
        charge_url: '/pwc/rest/card/mvva/pay',
        verify_url: '/pwc/rest/card/mvva/status'
      }.freeze

      ACCOUNT = {
        initiate_recurrent_url: '/pwc/rest/recurrent/account',
        charge_url: '/pwc/rest/account/pay',
        charge_recurrent_url: '/pwc/rest/recurrent/account/charge',
        validate_url: '/pwc/rest/account/pay/validate',
        validate_recurrent_url: '/pwc/rest/recurrent/account/validate',
        alt_validate_url: '/pwc/rest/accessbank/ussd/validate',
        resend_url: '/pwc/rest/account/pay/resendotp'
      }.freeze
    end
  end
end

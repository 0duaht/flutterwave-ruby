$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'flutterwave'
require 'minitest/autorun'
require 'webmock/minitest'
require 'faker'

module TestData
  COMMON_RESPONSE = {
    'transactionReference' => Faker::Crypto.md5[0, 7].upcase,
  }.freeze
end

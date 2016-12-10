require 'test_helper'
require 'base64'

class EncryptionManagerTest < Minitest::Test
  def setup
    @plain_text = 'flutterwave'
    @cipher_text = 'WmbH0cemRWB8zy/ZQS7gbA=='
    @key = 'tk_0f86a4ef436f76faab1d3'
  end

  def test_that_it_encrypts_appropriately
    assert_equal Flutterwave::EncryptionManager.encrypt(@plain_text, @key),
                 @cipher_text
  end

  def test_that_it_decrypts_appropriately
    assert_equal Flutterwave::EncryptionManager.decrypt(@cipher_text, @key),
                 @plain_text
  end
end

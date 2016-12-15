require 'test_helper'

class ClientTest < Minitest::Test
  def setup
    merchant_key = "tk_#{Faker::Crypto.md5[0, 10]}"
    api_key = "tk_#{Faker::Crypto.md5[0, 20]}"
    @client = Flutterwave::Client.new(merchant_key, api_key)
  end

  def test_that_it_has_bvn_instance
    refute_nil @client.instance_variable_get(:@bvn)
  end

  def test_that_it_has_bin_instance
    refute_nil @client.instance_variable_get(:@bin)
  end

  def test_that_it_has_ip_instance
    refute_nil @client.instance_variable_get(:@ip)
  end

  def test_that_it_has_bank_instance
    refute_nil @client.instance_variable_get(:@bank)
  end

  def test_that_it_has_card_instance
    refute_nil @client.instance_variable_get(:@card)
  end

  def test_that_it_has_account_instance
    refute_nil @client.instance_variable_get(:@account)
  end

  def test_that_it_has_ach_instance
    refute_nil @client.instance_variable_get(:@ach)
  end
end

require 'flutterwave/utils/network_manager'
require 'flutterwave/utils/encryption_manager'

module Flutterwave
  module Helpers
    def post(url, data)
      Flutterwave::Utils::NetworkManager.post(url, data)
    end

    def encrypt_data(plain_text, api_key)
      Flutterwave::Utils::EncryptionManager.encrypt(plain_text, api_key)
    end
  end
end
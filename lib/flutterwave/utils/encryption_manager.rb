require 'openssl'
require 'base64'

module Flutterwave
  module Utils
    module EncryptionManager
      KEY = Flutterwave::Utils::Constants::KEY

      def self.encrypt(text, key = KEY)
        key = digest(key)
        cipher = OpenSSL::Cipher::Cipher.new('des-ede3')
        cipher.encrypt
        cipher.key = key
        cipher_text = cipher.update(text.to_s)
        cipher_text << cipher.final

        Base64.encode64(cipher_text).gsub(/\n/, '')
      end

      def self.decrypt(text, key = KEY)
        key = digest(key)
        cipher = OpenSSL::Cipher::Cipher.new('des-ede3')
        cipher.decrypt
        cipher.key = key
        plain_text = cipher.update(Base64.decode64(text.to_s))

        plain_text << cipher.final
      end

      def self.digest(key)
        digest = Digest::MD5.digest(key)

        digest + digest[0, 8]
      end
    end
  end
end

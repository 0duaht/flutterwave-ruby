require 'openssl'
require 'base64'

module Flutterwave
  module EncryptionManager
    KEY = 'tk_0f86a4ef436f76faab1d3'.freeze

    def self.encrypt(text, key = KEY)
      key = digest(key)
      cipher = OpenSSL::Cipher::Cipher.new('des-ede3')
      cipher.encrypt
      cipher.key = key
      cipher_text = cipher.update(text)
      cipher_text << cipher.final

      Base64.encode64(cipher_text).gsub(/\n/, '')
    end

    def self.decrypt(text, key = KEY)
      key = digest(key)
      cipher = OpenSSL::Cipher::Cipher.new('des-ede3')
      cipher.decrypt
      cipher.key = key
      plain_text = cipher.update(Base64.decode64(text))

      plain_text << cipher.final
    end

    def self.digest(key)
      digest = Digest::MD5.digest(key)

      digest + digest[0, 8]
    end
  end
end

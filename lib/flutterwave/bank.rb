module Flutterwave
  class BankAPI
    attr_accessor :client

    def initialize(client)
      @client = client
    end

    def list
      response = post(
        Flutterwave::Utils::Constants::BANK[:list_url]
      )

      all_banks = response['data']
      all_banks.keys.inject([]) do |list, code|
        list << Bank.new(code, all_banks[code])
      end
    end

    def find_by_code(code)
      list.detect do |bank|
        bank.code == code
      end
    end

    def find_by_name(name_match)
      list.detect do |bank|
        !(bank.name.downcase =~ /#{name_match.downcase}/).nil?
      end
    end

    def post(url, data = {})
      Flutterwave::Utils::NetworkManager.post(url, data)
    end
  end

  class Bank
    attr_accessor :code, :name

    def initialize(code, name)
      @code = code
      @name = name
    end
  end
end

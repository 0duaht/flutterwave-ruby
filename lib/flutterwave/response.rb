module Flutterwave
  class Response
    attr_accessor :response

    def initialize(response)
      @response = response ? OpenStruct.new(response['data']) : OpenStruct.new({})
    end

    def successful?
      responseCode == '00'
    end

    def failed?
      !successful?
    end

    def method_missing(method, *args)
      return response.send(method, *args) if response.respond_to?(method)
      super
    end
  end
end

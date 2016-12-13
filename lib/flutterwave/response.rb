module Flutterwave
  class Response
    attr_accessor :response

    def initialize(response)
      @response = response ? OpenStruct.new(response['data']) : OpenStruct.new({})
    end

    def successful?
      (try('responseCode') || try('responsecode')) == '00'
    end

    def failed?
      !successful?
    end

    def method_missing(method_name, *args)
      return response.send(method_name, *args) if response.respond_to?(method_name)
      super
    end

    def try(method_name)
      instance_eval method_name
    rescue NameError
      nil
    end
  end
end

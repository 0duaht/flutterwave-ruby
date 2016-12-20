$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'flutterwave'
require 'minitest/autorun'
require 'webmock/minitest'
require 'faker'

module FlutterWaveTestHelper
  def stub_flutterwave
    stub_request(
      :post, "#{Flutterwave::Utils::Constants::BASE_URL}"\
      "#{url}"
    ).to_return(status: 200, body: response_data.to_json)
  end
end


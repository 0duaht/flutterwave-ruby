require 'test_helper'

class ACHTest < Minitest::Test
  def setup
    merchant_key = "tk_#{Faker::Crypto.md5[0, 10]}"
    api_key = "tk_#{Faker::Crypto.md5[0, 20]}"
    @client = Flutterwave::Client.new(merchant_key, api_key)
    @sample_institution = {
      'credentials' => {
        'password' => 'Password',
        'pin' => nil,
        'username' => 'Online ID'
      },
      'name' => 'Bank of America',
      'hasmfa' => true,
      'id' => '5301a93ac140de84910000e0',
      'type' => 'bofa',
      'mfatypes' => ['questions(3)']
    }
  end

  def stub_flutterwave
    stub_request(
      :post, "#{Flutterwave::Utils::Constants::BASE_URL}"\
      "#{@url}"
    ).to_return(status: 200, body: @response_data.to_json)
  end

  def response_container(institution_list)
    {
      'data' => {
        'institutions' => institution_list,
        'responsecode' => '00',
        'responsemessage' => '00',
        'transactionreference' => "FLW#{Faker::Number.number(8)}"
      },
      'status' => 'success'
    }
  end

  def sample_list_response
    institutions = [
      @sample_institution,
      @sample_institution,
      @sample_institution,
      @sample_institution
    ]

    response_container(institutions)
  end

  def sample_find_by_id_response
    response_container([@sample_institution])
  end

  def test_list
    @response_data = sample_list_response
    @url = Flutterwave::Utils::Constants::ACH[:list_url]

    stub_flutterwave

    response = @client.ach.list

    assert response.is_a? Array
    assert response.length == 4
    assert response.all? do |item|
      item.is_a? Flutterwave::Institution
    end
  end

  def test_find_by_id
    @response_data = sample_find_by_id_response
    @url = Flutterwave::Utils::Constants::ACH[:id_url]

    stub_flutterwave
    response = @client.ach.find_by_id(id: @sample_institution['id'])

    assert_equal @sample_institution['name'], response.name
  end

  def test_find_by_name
    @response_data = sample_list_response
    @url = Flutterwave::Utils::Constants::ACH[:list_url]

    stub_flutterwave

    @institution_instance = Flutterwave::Institution.new(@sample_institution)
    response = @client.ach.find_by_name('bank of america')

    assert_equal @sample_institution['id'], response.id
    assert_equal @sample_institution['name'], response.name
  end
end

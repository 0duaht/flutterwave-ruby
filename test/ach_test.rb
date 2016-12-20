require 'test_helper'

class ACHTest < Minitest::Test
  attr_reader :client, :sample_institution

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
      'name' => Faker::Company.name,
      'hasmfa' => true,
      'id' => Faker::Crypto.md5[0, 24],
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
    institutions = []
    4.times { institutions << sample_institution  }

    response_container(institutions)
  end

  def sample_find_by_id_response
    response_container([sample_institution])
  end

  def sample_charge_body
    {
      publictoken: Faker::Crypto.md5[0, 19].to_s,
      accountid: Faker::Number.number(2),
      custid: Faker::Number.number(2),
      narration: Faker::Lorem.sentence,
      amount: 1,
      currency: 'NGN',
      trxreference: "FLW#{Faker::Number.number(8)}"
    }
  end

  def sample_charge_response
    {
      'data' => {
        'responsetoken' => nil,
        'responsecode' => '00',
        'responsemessage' => 'Successful',
        'transactionreference' => "TST#{Faker::Number.number(9)}",
        'otptransactionidentifier' => nil,
        'responsehtml' => nil
      },
      'status' => 'success'
    }
  end

  def sample_add_user_body
    {
      username: Faker::Internet.user_name,
      password: Faker::Internet.password,
      pin: Faker::Number.number(4),
      email: Faker::Internet.email,
      institution: sample_institution['type'],
      country: Faker::Address.country_code
    }
  end

  def sample_add_user_response
    @sample_account = {
      'balance' => {
        'available' => Faker::Number.number(5),
        'current' => Faker::Number.number(4)
      },
      'meta' => {
        'limit' => nil,
        'name' => Faker::Company.name,
        'number' => Faker::Number.number(4)
      },
      'numbers' => nil,
      'type' => 'depository',
      'subtype' => 'savings',
      'id' => nil,
      'item' => nil,
      'user' => nil,
      'institutionType' => nil
    }

    {
      'data' => {
        'responsecode' => '00',
        'responsemessage' => Faker::Lorem.sentence,
        'transactionreference' => "FLWT#{Faker::Number.number(8)}",
        'accounts' => [
          @sample_account, @sample_account, @sample_account, @sample_account
        ]
      },
      'status' => 'success'
    }
  end

  def test_list
    @response_data = sample_list_response
    @url = Flutterwave::Utils::Constants::ACH[:list_url]

    stub_flutterwave

    response = client.ach.list

    assert response.successful?
    assert response.institutions.is_a? Array
    assert response.institutions.length == 4
  end

  def test_find_by_id
    @response_data = sample_find_by_id_response
    @url = Flutterwave::Utils::Constants::ACH[:id_url]

    stub_flutterwave
    response = client.ach.find_by_id(id: sample_institution['id'])

    assert_equal sample_institution['name'],
                 response.institutions.first['name']
  end

  def test_add_user
    @response_data = sample_add_user_response
    @url = Flutterwave::Utils::Constants::ACH[:add_user_url]

    stub_flutterwave
    response = client.ach.add_user(sample_add_user_body)

    assert response.successful?
    assert response.accounts.is_a? Array
    assert response.accounts.length == 4
  end

  def test_charge
    @response_data = sample_charge_response
    @url = Flutterwave::Utils::Constants::ACH[:charge_url]

    stub_flutterwave
    response = client.ach.charge(sample_charge_body)

    assert response.successful?
  end
end

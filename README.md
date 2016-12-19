# Flutterwave

Ruby SDK for convenient access to the Flutterwave API from Ruby applications. Full API documentation avaialable at https://www.flutterwave.com/documentation

## Installation

    gem install flutterwave

## Usage

The library needs to be configured with your merchant key and API key. These are accessible from the Settings panel at https://www.flutterwavedev.com/

To initialize the Ruby client:

```ruby
require 'flutterwave'

merchant_key = 'tk_aT0BPO14Rs'
api_key = 'tk_ybh0luGWQbM04Is15lXh'
client = Flutterwave::Client.new(merchant_key, api_key)
```

## API operations
All API operations are performed through the client instance. API responses are used to initialize a response class that allows direct access to JSON keys as methods. Arguments to operation methods adapt the same signature as sample requests to the API endpoint. For instance, an API call that returns:

```json
{
  "data": {
    "responsecode": "02",
    "responsemessage": "Successful, pending OTP validation",
    "transactionreference": "ABC1234444"
  },
  "status": "success"
}
```
Gets initialized as a `Flutterwave::Response` object with method keys - `responsecode`, `responsemessage`, `transactionreference`, `successful?`, `failed?`

## Examples
An example using the wrapper for accessing https://www.flutterwave.com/documentation/alternative-payments/
The resend-otp operation could be accessed through this sample:

```ruby
client = Flutterwave::Client.new('sample_merchant_key', 'sample_api_key')
response = client.account.resend({
  validateoption: 'SMS',
  transactionreference: 'FLW02391188'
})

print response.responsemessage if response.successful?
```

The method arguments to the resend method match the same hash-signature as the request sample at https://www.flutterwave.com/documentation/alternative-payments/#resend-otp. Response from the API is used to construct an instance of `Flutterwave::Response` which makes keys in the `data` hash accessible as methods.

## Banks Listing
The only operation that does not follow the description above is when obtaining listing of banks, alongside their codes and names. To ease operation with the listing, a `Flutterwave::Bank` object is created for each bank object returned by the API. The `Flutterwave::BankAPI` also comes with some helper methods that help find a bank by code, or by a regex matching the bank's name. An example usage is described below:

```ruby
client = Flutterwave::Client.new('sample_merchant_key', 'sample_api_key')
all_banks = client.bank.list
names_of_all_banks = all_banks.inject([]) { |list, bank| list << bank.name }

p names_of_all_banks # => ["Fidelity Bank", "Heritage"..."Unity Bank"]

# sample for finding a bank by name
access_bank_code = client.bank.find_by_name('access').code # => '044'

# sample for finding a bank by code
bank_name = client.bank.find_by_code('058').name # => GTBank Plc
```

## Mappings (API to Method)
Each method has the corresponding API link as a comment above the method signature. To access details about the arguments to the method, please see the tests for that class, or visit the API link.

## Development

Run all tests:

    bundle exec rake

Run a single test suite:

    bundle exec rake TEST=test/pay_test.rb

## Contributing

1. Fork it by visiting - https://github.com/0duaht/flutterwave-ruby/fork

2. Create your feature branch

        $ git checkout -b new_feature
    
3. Contribute to code

4. Commit changes made

        $ git commit -a -m 'descriptive_message_about_change'
    
5. Push to branch created

        $ git push origin new_feature
    
6. Then, create a new Pull Request
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flutterwave/version'

Gem::Specification.new do |spec|
  spec.name          = 'flutterwave'
  spec.version       = Flutterwave::VERSION
  spec.authors       = ['Tobi Oduah']
  spec.email         = ['tobi.oduah@andela.com']

  spec.summary       = 'Ruby client for interacting with Flutterwave APIs'
  spec.homepage      = 'https://github.com/0duaht/flutterwave-ruby'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'webmock'
end

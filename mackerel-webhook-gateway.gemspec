Gem::Specification.new do |spec|
  spec.name          = 'mackerel-webhook-gateway'
  spec.version       = '1.0.0'
  spec.authors       = ['Kenshi Muto']
  spec.email         = ['kmuto@kmuto.jp']
  spec.license       = 'MIT License'
  spec.metadata = { 'rubygems_mfa_required' => 'true' }

  spec.summary       = 'Mackerel Webhook Gateway is Webhook handler for Mackerel'
  spec.description   = 'This library provides Webhook gateway library and GoogleChat poster as example.'
  spec.homepage      = 'https://github.com/kmuto/mackerel-webhook-gateway'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/kmuto/mackerel-webhook-gateway'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('dotenv')
  spec.add_dependency('faraday')

  spec.add_development_dependency('rake', '~> 12.0')
  spec.add_development_dependency('rubocop', '~> 1.50')
  spec.add_development_dependency('rubocop-performance')
  spec.add_development_dependency('rubocop-rake')
end

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'worklog/version'

Gem::Specification.new do |spec|
  spec.name          = 'worklog'
  spec.version       = Worklog::VERSION
  spec.authors       = ['Carsten Braune']
  spec.email         = ['git@carsten-braune.de']

  spec.summary       = 'Time tracker'
  spec.description   = 'Tracks the work by topic and the breaks'
  spec.homepage      = 'https://github.com/cabb/worklog'
  spec.license       = 'MIT'

  #spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/cabb/worklog'
  spec.metadata['changelog_uri'] = 'https://github.com/cabb/worklog'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'guard', '~> 2.16'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'rake', '~> 13.0.0'
  spec.add_development_dependency 'rspec', '~> 3.9'
end

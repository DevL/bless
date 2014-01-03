# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bliss/version'

Gem::Specification.new do |spec|
  spec.name          = 'bliss'
  spec.version       = Bliss::VERSION
  spec.authors       = ['Lennart Fridén', 'Kim Persson']
  spec.email         = ['lennart@devl.se']
  spec.description   = %q{Blessed are the Perl hackers}
  spec.summary       = %q{Brings the blessings of Perl to Ruby}
  spec.homepage      = 'https://github.com/DevL/bliss'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'binding_of_caller', '~> 0.7'
  spec.add_development_dependency 'byebug', '~> 2.5'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'guard', '~> 2.2'
  spec.add_development_dependency 'guard-rspec', '~> 4.2'
end

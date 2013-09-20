# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'john_stamos/version'

Gem::Specification.new do |gem|
  gem.name          = "john_stamos"
  gem.version       = JohnStamos::VERSION
  gem.authors       = ["mariozig"]
  gem.email         = ["mariozig@gmail.com"]
  gem.description   = %q{A Pinterest client}
  gem.summary       = %q{An interface into Pinterest that exposes Pinners, Pins and searching. }
  gem.homepage      = "http://github.com/mariozig/john_stamos/"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'webmock', '~> 1.13'
  gem.add_development_dependency 'vcr', '~> 2.5'
  gem.add_development_dependency 'guard-rspec', '~> 3.0'

  gem.add_dependency 'nokogiri', '~> 1.6'
  gem.add_dependency 'faraday', '~> 0.8'
  gem.add_dependency 'typhoeus', '~> 0.6'
  gem.add_dependency 'json', '~> 1.8'
  gem.add_dependency 'launchy', '~> 2.3'
end

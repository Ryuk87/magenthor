# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'magenthor/version'

Gem::Specification.new do |spec|
  spec.name          = "magenthor"
  spec.version       = Magenthor::VERSION
  spec.authors       = ["Daniele Lenares"]
  spec.email         = ["daniele.lenares@gmail.com"]
  spec.summary       = %q{A Rubygem wrapper for the XMLRPC Magento API.}
  spec.description   = %q{A Rubygem wrapper for the XMLRPC Magento API.}
  spec.homepage      = "https://github.com/Ryuk87/magenthor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0"
end

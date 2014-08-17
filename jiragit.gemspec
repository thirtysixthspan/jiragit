# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jiragit/version'

Gem::Specification.new do |spec|
  spec.name          = "jiragit"
  spec.version       = Jiragit::VERSION
  spec.authors       = ["Derrick Parkhurst"]
  spec.email         = ["derrick.parkhurst@gmail.com"]
  spec.summary       = %q{Integrate Jira and Git}
  spec.description   = %q{add jira numbers and urls to your commits automatically}
  spec.homepage      = "http://null"
  spec.license       = "MIT"

  spec.files         = Dir['Rakefile', '{hooks,bin,lib,spec}/**/*', 'README*', 'LICENSE*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.1"
end

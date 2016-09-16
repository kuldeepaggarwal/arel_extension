# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arel_extension/version'

Gem::Specification.new do |spec|
  spec.name          = "arel_extension"
  spec.version       = ArelExtension::VERSION
  spec.authors       = ["Kuldeep Aggarwal"]
  spec.email         = ["kd.engineer@yahoo.co.in"]

  spec.summary       = %q{Extension of Arel Gem}
  spec.description   = %q{Extension of Arel Gem.}
  spec.homepage      = "https://github.com/kuldeepaggarwal/arel_extension"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'arel', '>= 4'

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end

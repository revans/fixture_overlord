# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fixture_overlord/version'

Gem::Specification.new do |gem|
  gem.name          = "fixture_overlord"
  gem.version       = FixtureOverlord.version
  gem.authors       = ["Robert Evans"]
  gem.email         = ["robert@codewranglers.org"]
  gem.description   = %q{A Rails Gem for handling Fixtures without a database. Allows mocks, stubs, hashes, model object, and inserting into the database when you want it to. No need for the bloat of FactoryGirl or other Object Factory Gems.}
  gem.summary       = %q{Handling Fixtures the right way, within a Rails application.}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency "activesupport", ">= 4.1.0.beta1"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rdoc"
  gem.add_development_dependency "minitest"
end

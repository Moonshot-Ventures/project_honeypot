# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'project_honeypot/version'

Gem::Specification.new do |s|
  s.name = %q{project_honeypot}
  s.version = ProjectHoneypot::VERSION
  s.authors = ["Charles Max Wood", "Guillaume DOTT"]
  s.email = ["chuck@teachmetocode.com", "guillaume+github@dott.fr"]
  s.summary = %q{Project-Honeypot provides a programatic interface to the Project Honeypot services.}
  s.description = %q{Project-Honeypot provides a programatic interface to the Project Honeypot services. It can be used to identify spammers, bogus commenters, and harvesters. You will need a FREE api key from http://projecthoneypot.org}
  s.homepage = ""

  s.files = `git ls-files`.split($/)
  s.executables = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'flexmock'

  s.add_runtime_dependency 'net-dns'
end

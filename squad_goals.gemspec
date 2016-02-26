# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'squad_goals/version'

Gem::Specification.new do |spec|
  spec.name          = 'squad_goals'
  spec.version       = SquadGoals::VERSION
  spec.authors       = ['Ben Balter']
  spec.email         = ['ben.balter@github.com']

  spec.summary       = 'A tiny app to allow open-source contributors to opt-in to GitHub teams.'
  spec.homepage      = "https://github.com/benbalter/squad_goals"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'warden-github', '~> 1.1'
  spec.add_dependency 'sinatra_auth_github', '~> 1.1'
  spec.add_dependency 'octokit', '~> 4.0'
  spec.add_dependency 'rack-ssl-enforcer', '~> 0.2'
  spec.add_dependency 'dotenv', '~> 2.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'webmock', '~> 1.2 '
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.37'
end

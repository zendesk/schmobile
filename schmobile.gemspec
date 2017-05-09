require './lib/schmobile/version'

Gem::Specification.new do |s|
  s.name        = 'schmobile'
  s.version     = Schmobile::VERSION
  s.files       = `git ls-files`.split("\n")
  s.license     = 'Apache License Version 2.0'

  s.summary     = 'A mobile user agent detection Rack middleware.'
  s.description = 'A mobile user agent detection Rack middleware. See the README.'

  s.authors  = ['Morten Primdahl', 'Pierre Schambacher']
  s.email    = %w[primdahl@me.com pschambacher@zendesk.com]
  s.homepage = 'http://github.com/zendesk/schmobile'

  s.required_ruby_version = '>= 2.2.0'

  s.require_paths = %w[lib]

  s.add_runtime_dependency('rack')

  s.add_development_dependency('rake')
  s.add_development_dependency('bundler')
  s.add_development_dependency('wwtd')
  s.add_development_dependency('bump')
  s.add_development_dependency('rspec')

  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end

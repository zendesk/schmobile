Gem::Specification.new "Schmobile", "1.0.0" do |s|
  s.name        = 'schmobile'
  s.date        = '2012-06-14'
  s.files       = `git ls-files`.split("\n")
  s.license     = "Apache License Version 2.0"

  s.summary     = "A mobile user agent detection Rack middleware."
  s.description = "A mobile user agent detection Rack middleware. See the README."

  s.authors  = ["Morten Primdahl"]
  s.email    = 'primdahl@me.com'
  s.homepage = 'http://github.com/zendesk/schmobile'

  s.require_paths = %w[lib]

  s.add_runtime_dependency("rack")

  s.add_development_dependency('rake')
  s.add_development_dependency('bundler')
  s.add_development_dependency('shoulda')
  s.add_development_dependency('mocha')

  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

Gem::Specification.new do |s|
  s.name = 'sequel-factory'
  s.version = '1.0.0'
  s.date = Time.now.strftime('%Y-%m-%d')

  s.summary = 'Simple, powerful factories for Sequel models'
  s.description = 'Simple, powerful factories for Sequel models'

  s.author = 'Michael Jackson'
  s.email = 'mjijackson@gmail.com'

  s.require_paths = %w< lib >

  s.files = Dir['lib/**/*.rb'] +
    %w< sequel-factory.gemspec Rakefile README.md >

  s.add_dependency('sequel', '>= 3.32')
  s.add_development_dependency('rake')

  s.homepage = 'http://mjijackson.github.com/sequel-factory'
end

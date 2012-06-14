Gem::Specification.new do |s|
  s.name        = 'pwup'
  s.version     = '0.0.3'
  s.date        = '2012-06-08'
  s.summary     = "Picasa Web Uploader"
  s.description = "A simple picasa web uploador utility class that support compressed archives (.rar, .zip)"
  s.authors     = ["Esteban Feldman"]
  s.email       = 'esteban.feldman@gmail.com'
  s.files       = Dir['lib/**/*.rb'] + Dir['bin/*']
  s.homepage    =
    'https://github.com/eka/pwup'
  s.executables << 'pwupcli'
  s.add_dependency("xml-simple")
  s.requirements << "unrar cli"
  s.requirements << "unzip cli"
end
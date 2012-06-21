require "date"

Gem::Specification.new do |s|
  s.name        = 'pwup'
  s.version     = '0.0.7'
  s.date        = Date.today.to_s
  s.summary     = "Picasaweb Uploader"
  s.description = "A simple picasaweb uploader utility class that support compressed archives (.rar, .zip)"
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
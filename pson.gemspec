Gem::Specification.new do |s|
  s.name = 'pson'
  s.version = '1.0.1'
  s.date = '2014-10-23'
  s.homepage = 'https://github.com/digwuren/pson'
  s.summary = 'Convert data to PostScript notation'
  s.author = 'Andres Soolo'
  s.email = 'dig@mirky.net'
  s.files = File.read('Manifest.txt').split(/\n/)
  s.license = 'GPL-3'
  s.description = <<EOD
This library, called PSON for PostScript Object Notation,
converts a Ruby number, string, symbol, array, hash, or Boolean
value into PostScript code constructing the matching PostScript
object.  Invoked via the [[to_postscript]] method on each
supported object.
EOD
  s.has_rdoc = true
end

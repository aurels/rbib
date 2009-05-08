Gem::Specification.new do |s|
  s.name        = "rbib"
  s.version     = "1.2"
  s.date        = "2009-05-07"
  s.summary     = "BibTeX parser in Ruby"
  s.email       = "aurelien.malisart@gmail.com"
  s.homepage    = "http://github.com/aurels/rbib"
  s.description = "BibTeX parser in Ruby"
  s.has_rdoc    = false
  s.authors     = ["Nick Gasson", "Aurélien Malisart"]
  s.files       = ['README', 'lib/bibtex.rb'] + Dir['lib/bibtex/*.rb'] + Dir['test/*.rb'] + Dir['examples/*.rb'] + Dir['examples/*.bib']
end
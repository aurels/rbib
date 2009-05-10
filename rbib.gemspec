# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rbib}
  s.version = "1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nick Gasson, Aur\303\251lien Malisart"]
  s.date = %q{2009-05-10}
  s.description = %q{BibTeX parser written in Ruby}
  s.email = %q{aurelien.malisart@gmail.com}
  s.extra_rdoc_files = ["lib/bibtex/bibliography.rb", "lib/bibtex/entry.rb", "lib/bibtex/field.rb", "lib/bibtex/lexer.rb", "lib/bibtex/parser.rb", "lib/bibtex.rb", "README.rdoc"]
  s.files = ["examples/example.bib", "examples/glom_citeulike.rb", "examples/tara_no_url.rb", "lib/bibtex/bibliography.rb", "lib/bibtex/entry.rb", "lib/bibtex/field.rb", "lib/bibtex/lexer.rb", "lib/bibtex/parser.rb", "lib/bibtex.rb", "Manifest", "Rakefile", "rbib.gemspec", "README.rdoc", "test/run_unit_tests.rb", "test/test_bibliography.rb", "test/test_entry.rb", "test/test_field.rb", "test/test_lexer.rb", "test/test_parser.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/aurels/rbib}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rbib", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rbib}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{BibTeX parser written in Ruby}
  s.test_files = ["test/test_bibliography.rb", "test/test_entry.rb", "test/test_field.rb", "test/test_lexer.rb", "test/test_parser.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

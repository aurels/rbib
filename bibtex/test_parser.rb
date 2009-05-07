require 'bibtex/parser'
require 'test/unit'

class TestParser < Test::Unit::TestCase
  include BibTeX
  
  def test_basic
    b = Parser.parse 'example.bib'

    ryan98 = b['ryan98']
    assert_kind_of Entry, ryan98
    assert_equal EntryType::Article, ryan98.type
    assert_equal 1998, ryan98[:year].to_i
  end

  def test_parse_reparse
    fname = '/tmp/example.bib.stripped'
    b = Parser.parse 'example.bib'
    b.save fname
    Parser.parse fname
    File.delete fname    
  end
end

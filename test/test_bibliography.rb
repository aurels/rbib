require 'bibtex/bibliography'
require 'test/unit'

class TestBibliography < Test::Unit::TestCase
  include Bibtex

  def setup
    @b = Bibliography.new

    @foo01 = Entry.new(EntryType::Book, 'foo01')
    @foo01.add_field :author, 'C. Doof'
    @foo01.add_field :year, 2007
    @foo01.add_field Field.new(:url, 'www.doof.me.uk')

    @bar99 = Entry.new(EntryType::Article, 'bar99')
    @bar99.add_field :author, 'N. Cakesniffer'
    @bar99.add_field :year, 1999
    @bar99.add_field Field.new(:url, 'www.cakesniffer.co.uk')

    @b << @foo01
    @b << @bar99
  end

  def test_basic
    assert_equal 2, @b.entries.length
    assert_equal @foo01, @b['foo01']
  end

  def test_map
    expect = <<END
@article{bar99,
  author = {N. Cakesniffer},
  year = {1999}
}

@book{foo01,
  author = {C. Doof},
  year = {2007}
}

END
    urlless = @b.map do |e|
      e.reject_fields [:url]
    end
    assert_equal expect, urlless.to_s    
  end

  def test_to_s
    expect = <<END
@article{bar99,
  author = {N. Cakesniffer},
  url = {www.cakesniffer.co.uk},
  year = {1999}
}

@book{foo01,
  author = {C. Doof},
  url = {www.doof.me.uk},
  year = {2007}
}

END
    assert_equal expect, @b.to_s
  end

  def test_save
    fname = '/tmp/_test.bib'
    @b.save fname

    f = File.new(fname)
    assert_equal @b.to_s, f.read
    f.close
    File.delete fname
  end
  
end

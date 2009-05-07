require 'bibtex/field'
require 'test/unit'

class TestField < Test::Unit::TestCase
  include BibTeX

  def test_basic
    f = Field.new(:author, 'C. Doof')
    assert_equal :author, f.key
    assert_equal 'C. Doof', f.value
  end

  def test_to_s
    f = Field.new(:author, 'C. Doof')
    assert_equal 'author = {C. Doof}', f.to_s
  end
end

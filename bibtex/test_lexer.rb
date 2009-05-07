require 'bibtex/lexer'
require 'test/unit'

class TestLexer < Test::Unit::TestCase
  include BibTeX
  
  def test_basic
    l = Lexer.new do |rules|
      rules.match /a/, :a
      rules.match /b+/, :bs
      rules.match /\s+/, :space
      rules.match /hello/, :hello
    end
    l.feed 'aabbb  hello'

    assert_equal :a, l.next_token!
    assert_equal :a, l.next_token!
    assert_equal :bs, l.next_token!
    assert_equal :space, l.next_token!
    assert_equal :hello, l.peek_token
    assert_equal 'hello', l.peek_lval
    assert_equal :hello, l.next_token!

    assert (not l.more_tokens?)
    assert_raise LexerError do
      l.next_token!
    end
  end

  def test_prec
    l = Lexer.new do |rules|
      rules.match /a/, :aye
      rules.match /a+/, :bad
      rules.match /.*/, :other
    end
    l.feed 'aa'
    assert_equal :aye, l.next_token!
    assert_equal :aye, l.next_token!
    assert (not l.more_tokens?)
  end

  def test_whitespace
    l = Lexer.new(false) do |rules|
      rules.match /\w+/, :word
    end
    l.feed " hello\t\n  world   "

    assert (not l.ignore_whitespace)
    l.ignore_whitespace = true

    assert_equal :word, l.next_token!
    assert_equal 'hello', l.lval
    assert_equal :word, l.next_token!
    assert_equal 'world', l.lval
    assert (not l.more_tokens?)
  end

  def test_src_pos
    l = Lexer.new do |rules|
      rules.match /a/, :a
      rules.match /\n/, :newline
    end
    l.feed 'aaaab'

    4.times { l.next_token! }
    begin
      l.next_token!
      flunk 'No exception raised'
    rescue LexerError => e
      assert_kind_of SourcePos, e.src_pos
      assert_equal 1, e.src_pos.line
      assert_equal 4, e.src_pos.column
    end

    l.ignore_newlines = false
    l.feed "aa\nab"

    l.file_name = 'My File'

    2.times { l.next_token! }
    assert_equal :newline, l.next_token!
    assert_equal :a, l.next_token!
    begin
      l.next_token!
      flunk 'No error raised'
    rescue LexerError => e
      assert_equal 2, e.src_pos.line
      assert_equal 1, e.src_pos.column
      assert_equal 'My File', e.src_pos.file
    end
  end

  def test_literals
    l = Lexer.new do |rules|
      rules.literals [:aye, :bee]
    end
    l.feed 'ayebeebee'

    assert_equal :aye, l.next_token!
    assert_equal :bee, l.next_token!
    assert_equal :bee, l.next_token!
  end

  def test_refeed
    l = Lexer.new do |rules|
      rules.match /a/, :a
      rules.match /b/, :b
    end
    l.feed 'aaa'

    assert_equal :a, l.next_token!
    l.feed 'bb'
    assert l.more_tokens?
    assert_equal :b, l.next_token!
  end
end

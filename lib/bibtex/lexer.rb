require 'strscan'

module Bibtex
  class SourcePos
    attr_reader :line, :column, :file
    
    def initialize(line, column, file)
      @line = line
      @column = column
      @file = file
    end

    def to_s
      "#{file}:#{line}"
    end
  end

  class RuleSet
    def initialize
      @rules = []
    end

    def match(regexp, result)
      @rules << [regexp, result]
    end

    def literals(words)
      words.each do |w|
        match(/#{w}/, w)
      end
    end

    def each
      @rules.each do |pair|
        yield pair[0], pair[1]
      end
    end
  end

  class LexerError < RuntimeError
    attr_reader :src_pos
    
    def initialize(mess, src_pos)
      super(mess)
      @src_pos = src_pos
    end
  end

  class Lexer
    attr_reader :lval, :ignore_whitespace
    attr_accessor :ignore_newlines, :file_name
    
    def initialize(ignore_whitespace = false)
      @scanner = StringScanner.new('')
      @rules = RuleSet.new
      @ignore_whitespace = ignore_whitespace
      @ignore_newlines = ignore_whitespace
      @lineno = 1
      @file_name = '<unknown>'
      yield @rules
    end

    # ignore_whitespace turns on ignore_newlines too
    def ignore_whitespace=(b)
      @ignore_whitespace = b
      @ignore_newlines = b
    end
    
    def feed(str)
      @scanner = StringScanner.new(str)
      @cols_prev = 0
    end

    def src_pos
      SourcePos.new(@lineno, @scanner.pos - @cols_prev, @file_name)
    end
    
    def next_token!
      if @scanner.check(/^\s*\n/) then
        @lineno += 1
        @cols_prev = @scanner.pos + 1
      end
      skip_whitespace
      @rules.each do |regexp, result|
        return result if @lval = @scanner.scan(regexp)
      end
      unexpect = if @scanner.rest.length < 10 then
                   @scanner.rest
                 else
                   "#{@scanner.rest.first 10}..."
                 end
      raise LexerError.new("Unexpected input #{unexpect}", src_pos)
    end

    def peek_token
      tok = self.next_token!
      @scanner.unscan
      return tok
    end

    def peek_lval
      peek_token
      @lval
    end

    def more_tokens?
      skip_whitespace
      not @scanner.eos?
    end

    private

    def skip_whitespace
      if @ignore_newlines and @ignore_whitespace then
        @scanner.skip(/\s+/)
      elsif @ignore_whitespace then
        @scanner.skip(/[ \t\r]+/)
      elsif @ignore_newlines  then
        @scanner.skip(/[\r\n]+/)
      end
    end
  end
end

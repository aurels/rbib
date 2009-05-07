require 'bibtex/bibliography'
require 'bibtex/entry'
require 'bibtex/field'
require 'bibtex/lexer'

module BibTeX

  class Parser
    def self.parse(filename)
      parse_string File.read(filename)
    end

    def self.parse_string(data)
      @lexer.feed data

      b = Bibliography.new
      while @lexer.more_tokens?
        b << parse_entry
      end
      return b
    end

    private

    def self.parse_entry
      expect :at, '@'
      type = expect :id
      expect :lbrace, '{'
      key = expect :id

      e = Entry.new(type, key)
      while @lexer.peek_token != :rbrace
        expect :comma, ','
        e.add_field parse_field
      end

      expect :rbrace, '}'
      return e
    end

    def self.parse_field
      key = expect :id
      expect :equals, '='
      value = parse_value
      Field.new(key.intern, value)
    end

    def self.parse_value
      close = :rbrace
      if @lexer.peek_token == :dquote then
        expect :dquote
        close = :dquote
      else
        expect :lbrace, '{'
      end

      brace_count = 1
      str = ''
      @lexer.ignore_whitespace = false
      @lexer.ignore_newlines = true
      loop do
        unless @lexer.more_tokens?
          raise 'Unexpected end of input'
        end
        
        case @lexer.next_token!
        when :rbrace, close
          brace_count -= 1
          if brace_count == 0 then
            @lexer.ignore_whitespace = true
            return str
          else
            str += '}'
          end
        when :lbrace
          str += '{'
          brace_count += 1
        else
          str += @lexer.lval
        end
      end
    end

    def self.expect(token, pretty = nil)
      pretty ||= token.to_s
      got = @lexer.next_token!
      unless got == token then
        raise "#{@lexer.src_pos}: Expected '#{pretty}' but found '#{got}'"
      else
        @lexer.lval
      end
    end

    @lexer = Lexer.new(true) do |rules|
      rules.match /@/, :at
      rules.match /\{/, :lbrace
      rules.match /\}/, :rbrace
      rules.match /\"/, :dquote
      rules.match /\=/, :equals
      rules.match /\,/, :comma
      rules.match /[\w\-_:]+/, :id
      rules.match /.+?/, :cdata
    end
  end
  
end

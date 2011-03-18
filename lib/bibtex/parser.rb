require 'bibtex/bibliography'
require 'bibtex/entry'
require 'bibtex/field'
require 'bibtex/lexer'

module Bibtex

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
      brace_count = 1
      if @lexer.peek_token == :dquote then
        expect :dquote
        close = :dquote
      elsif @lexer.peek_token == :lbrace then
        expect :lbrace, '{'
      else
        # Not surrounded by quotes or braces
        brace_count = 0
      end

      str = ''
      @lexer.ignore_whitespace = false
      @lexer.ignore_newlines = true
      loop do
        unless @lexer.more_tokens?
          raise 'Unexpected end of input'
        end

        if (@lexer.peek_token == :comma \
            or @lexer.peek_token == :rbrace) and brace_count == 0 then
          # A field not delimited by "" or {}
          @lexer.ignore_whitespace = true
          return str
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
        raise "#{@lexer.src_pos}: Expected '#{pretty}' but found token '#{got}' (text='#{@lexer.lval}')"
      else
        @lexer.lval
      end
    end

    @lexer = Lexer.new(true) do |rules|
      rules.match(/@/,:at)
      rules.match(/\{/,:lbrace)
      rules.match(/\}/,:rbrace)
      rules.match(/\"/,:dquote)
      rules.match(/\=/,:equals)
      rules.match(/\,/,:comma)
      rules.match(/[\w\-:&]+/,:id)
      rules.match(/.+?/,:cdata)
    end
  end
  
end

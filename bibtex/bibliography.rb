require 'bibtex/entry'

module BibTeX
  
  class Bibliography    
    attr_reader :entries

    def initialize
      @entries = {}
    end
    
    def <<(e)
      if e.kind_of? Entry then
        @entries[e.key] = e
      else
        raise 'Cannot add non-entries to bibliography'
      end
    end

    def [](key)
      @entries[key] or raise "No entry #{key}"
    end

    # Transform the entries in some way and return a
    # new bibliography
    def map
      r = Bibliography.new
      @entries.each do |k, e|
        r << yield(e)
      end
      return r
    end

    def save(filename)
      f = File.new(filename, 'w')
      f.puts self.to_s
      f.close
    end

    def to_s
      @entries.keys.sort.collect { |k| @entries[k].to_s }.join
    end
  end
  
end

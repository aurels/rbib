module Bibtex

  # A single entry in a bibliography
  class Entry
    attr_reader :type, :key
    
    def initialize(type, key)
      @type = type
      @key = key
      @fields = {}
      $stderr.print key,"\n" if $DEBUG
    end

    def add_field(obj, value = nil)
      if obj.kind_of? Field then
        @fields[obj.key] = obj
      else
        @fields[obj] = Field.new(obj, value)
      end
    end

    def [](key)
      f = @fields[key]
      f = @fields[key.to_s.downcase.to_sym] if !f
      if f then
        f.value
      else
        # raise "No field with key #{key}"
        ""
      end
    end

    def has? key
      field = self[key]
      field != nil and field.strip != ''
    end

    # Make sure the field exists and has meaningful data
    def required key
      if !has?(key)
        $stderr.print self
        raise "Key #{key} does not exist"
      end
      self[key]
    end


    def to_s
      fs = @fields.collect { |k, f| "  #{f.to_s}" }.sort.join ",\n"
      "@#{@type}{#{@key},\n#{fs}\n}\n\n"
    end

    def reject_fields(keys)
      r = Entry.new(@type, @key)
      @fields.each do |k, f|
        r.add_field f unless keys.index k
      end
      return r
    end

    def select_fields(keys)
      r = Entry.new(@type, @key)
      @fields.each do |k, f|
        r.add_field f if keys.index k
      end
      return r
    end 

  end

  # Different types of entries
  module EntryType
    Book = 'book'
    Article = 'article'
    Booklet = 'booklet'
    Conference = 'conference'
    InBook = 'inbook'
    InCollection = 'incollection'
    InProceedings = 'inproceedings'
    Manual = 'manual'
    MastersThesis = 'mastersthesis'
    Misc = 'misc'
    PhDThesis = 'phdthesis'
    Proceedings = 'proceedings'
    TechReport = 'techreport'
    Unpublished = 'unpublished'
  end
  
end

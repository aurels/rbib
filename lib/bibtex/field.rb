module BibTeX

  # A field within an entry E.g. author = {Foo}
  class Field
    attr_reader :key, :value

    def initialize(key, value)
      @key = key
      @value = value
    end

    def to_s
      "#{@key} = {#{@value}}"
    end
  end
  
end

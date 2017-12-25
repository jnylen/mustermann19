require 'mustermann19'

module Mustermann19
  # Mixin for adding {#to_pattern} ducktyping to objects.
  #
  # @example
  #   require 'mustermann/to_pattern'
  #
  #   class Foo
  #     include Mustermann19::ToPattern
  #
  #     def to_s
  #       ":foo/:bar"
  #     end
  #   end
  #
  #   Foo.new.to_pattern # => #<Mustermann19::Sinatra:":foo/:bar">
  #
  # By default included into String, Symbol, Regexp, Array and {Mustermann19::Pattern}.
  module ToPattern
    PRIMITIVES = [String, Symbol, Array, Regexp, Mustermann19::Pattern]
    #private_constant :PRIMITIVES

    # Converts the object into a {Mustermann19::Pattern}.
    #
    # @example converting a string
    #   ":name.png".to_pattern # => #<Mustermann19::Sinatra:":name.png">
    #
    # @example converting a string with options
    #   "/*path".to_pattern(type: :rails) # => #<Mustermann19::Rails:"/*path">
    #
    # @example converting a regexp
    #   /.*/.to_pattern # => #<Mustermann19::Regular:".*">
    #
    # @example converting a pattern
    #   Mustermann19.new("foo").to_pattern # => #<Mustermann19::Sinatra:"foo">
    #
    # @param [Hash] options The options hash.
    # @return [Mustermann19::Pattern] pattern corresponding to object.
    def to_pattern(options = {})
      input   = self if PRIMITIVES.any? { |p| self.is_a? p }
      input ||= __getobj__ if respond_to?(:__getobj__)
      Mustermann19.new(input || to_s, options)
    end

    PRIMITIVES.each do |klass|
      append_features(klass)
    end
  end
end

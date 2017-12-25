require 'mustermann19/regexp_based'

module Mustermann19
  # Regexp pattern implementation.
  #
  # @example
  #   Mustermann19.new('/.*', type: :regexp) === '/bar' # => true
  #
  # @see Mustermann19::Pattern
  # @see file:README.md#simple Syntax description in the README
  class Regular < RegexpBased
    register :regexp, :regular

    # @param (see Mustermann19::Pattern#initialize)
    # @return (see Mustermann19::Pattern#initialize)
    # @see (see Mustermann19::Pattern#initialize)
    def initialize(string, options = {})
      string = $1 if string.to_s =~ /\A\(\?\-mix\:(.*)\)\Z/ && string.inspect == "/#$1/"
      super(string, options)
    end

    def compile(options = {})
      /#{@string}/
    end

    private :compile
  end
end

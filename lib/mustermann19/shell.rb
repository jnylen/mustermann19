require 'mustermann19/pattern'
require 'mustermann19/simple_match'

module Mustermann19
  # Matches strings that are identical to the pattern.
  #
  # @example
  #   Mustermann19.new('/*.*', type: :shell) === '/bar' # => false
  #
  # @see Mustermann19::Pattern
  # @see file:README.md#shell Syntax description in the README
  class Shell < Pattern
    register :shell

    # @param (see Mustermann19::Pattern#initialize)
    # @return (see Mustermann19::Pattern#initialize)
    # @see (see Mustermann19::Pattern#initialize)
    def initialize(string, options = {})
      @flags = File::FNM_PATHNAME | File::FNM_DOTMATCH
      @flags |= File::FNM_EXTGLOB if defined? File::FNM_EXTGLOB
      super(string, options)
    end

    # @param (see Mustermann19::Pattern#===)
    # @return (see Mustermann19::Pattern#===)
    # @see (see Mustermann19::Pattern#===)
    def ===(string)
      File.fnmatch? @string, unescape(string), @flags
    end

    # @param (see Mustermann19::Pattern#peek_size)
    # @return (see Mustermann19::Pattern#peek_size)
    # @see (see Mustermann19::Pattern#peek_size)
    def peek_size(string)
      @peek_string ||= @string + "{**,/**,/**/*}"
      super if File.fnmatch? @peek_string, unescape(string), @flags
    end
  end
end

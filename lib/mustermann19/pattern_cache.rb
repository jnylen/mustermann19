require 'set'
require 'thread'
require 'mustermann19'

module Mustermann19
  # A simple, persistent cache for creating repositories.
  #
  # @example
  #   require 'mustermann/pattern_cache'
  #   cache = Mustermann19::PatternCache.new
  #
  #   # use this instead of Mustermann19.new
  #   pattern = cache.create_pattern("/:name", type: :rails)
  #
  # @note
  #   {Mustermann19::Pattern.new} (which is used by {Mustermann19.new}) will reuse instances that have
  #   not yet been garbage collected. You only need an extra cache if you do not keep a reference to
  #   the patterns around.
  #
  # @api private
  class PatternCache
    # @param [Hash] pattern_options default options used for {#create_pattern}
    def initialize(pattern_options = {})
      @cached          = Set.new
      @mutex           = Mutex.new
      @pattern_options = pattern_options
    end

    # @param (see Mustermann19.new)
    # @return (see Mustermann19.new)
    # @raise (see Mustermann19.new)
    # @see Mustermann19.new
    def create_pattern(string, pattern_options = {})
      pattern = Mustermann19.new(string, @pattern_options.merge(pattern_options))
      @mutex.synchronize { @cached.add(pattern) } unless @cached.include? pattern
      pattern
    end

    # Removes all pattern instances from the cache.
    def clear
      @mutex.synchronize { @cached.clear }
    end

    # @return [Integer] number of currently cached patterns
    def size
      @mutex.synchronize { @cached.size }
    end
  end
end

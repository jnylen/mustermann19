require 'mustermann19/ast/translator'

module Mustermann19
  module AST
    # Checks the AST for certain validations, like correct capture names.
    #
    # Internally a poor man's visitor (abusing translator to not have to implement a visitor).
    # @!visibility private
    class Validation < Translator
      # Runs validations.
      #
      # @param [Mustermann19::AST::Node] ast to be validated
      # @return [Mustermann19::AST::Node] the validated ast
      # @raise [Mustermann19::AST::CompileError] if validation fails
      # @!visibility private
      def self.validate(ast)
        new.translate(ast)
        ast
      end

      translate(Object, :splat) {}
      translate(:node) { t(payload) }
      translate(Array) { each { |p| t(p)} }
      translate(:capture) { t.check_name(name, forbidden: ['captures', 'splat'])}
      translate(:variable, :named_splat) { t.check_name(name, forbidden: 'captures')}

      # @raise [Mustermann19::CompileError] if name is not acceptable
      # @!visibility private
      def check_name(name, options = {})
        forbidden = options[:forbidden]
        raise CompileError, "capture name can't be empty" if name.nil? or name.empty?
        raise CompileError, "capture name must start with underscore or lower case letter" unless name =~ /^[a-z_]/
        raise CompileError, "capture name can't be #{name}" if Array(forbidden).include? name
        raise CompileError, "can't use the same capture name twice" if names.include? name
        names << name
      end

      # @return [Array<String>] list of capture names in tree
      # @!visibility private
      def names
        @names ||= []
      end
    end
  end
end

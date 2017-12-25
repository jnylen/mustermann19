require 'mustermann19/ast/translator'

module Mustermann19
  module AST
    # Scans an AST for param converters.
    # @!visibility private
    # @see Mustermann19::AST::Pattern#to_templates
    class ParamScanner < Translator
      # @!visibility private
      def self.scan_params(ast)
        new.translate(ast)
      end

      translate(:node)    { t(payload) }
      translate(Array)    { map { |e| t(e) }.inject(:merge) }
      translate(Object)   { {} }
      translate(:capture) { convert ? { name => convert } : {} }
    end
  end
end

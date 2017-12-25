require 'mustermann19/ast/translator'

module Mustermann19
  module AST
    # Turns an AST into a human readable string.
    # @!visibility private
    class TreeRenderer < Translator
      # @example
      #   Mustermann19::AST::TreeRenderer.render Mustermann19::Sinatra::Parser.parse('/foo')
      #
      # @!visibility private
      def self.render(ast)
        new.translate(ast)
      end

      translate(Object) { inspect }
      translate(Array) { map { |e| "\n" << t(e) }.join.gsub("\n", "\n  ") }
      translate(:node) { "#{node.type} #{t(payload)}" }
      translate(:with_look_ahead) { "#{node.type} #{t(head)} #{t(payload)}" }
    end
  end
end

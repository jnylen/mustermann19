require 'sinatra/version'
fail "no need to load the Mustermann19 extension for #{::Sinatra::VERSION}" if ::Sinatra::VERSION >= '2.0.0'

require 'mustermann19'

module Mustermann19
  # Sinatra 1.x extension switching default pattern parsing over to Mustermann19.
  #
  # @example With classic Sinatra application
  #   require 'sinatra'
  #   require 'mustermann'
  #
  #   register Mustermann19
  #   get('/:id', capture: /\d+/) { ... }
  #
  # @example With modular Sinatra application
  #   require 'sinatra/base'
  #   require 'mustermann'
  #
  #   class MyApp < Sinatra::Base
  #     register Mustermann19
  #     get('/:id', capture: /\d+/) { ... }
  #   end
  #
  # @see file:README.md#Sinatra_Integration "Sinatra Integration" in the README
  module Extension
    def compile!(verb, path, block, options = {})
      except  = options.delete(:except)
      capture = options.delete(:capture)
      pattern = options.delete(:pattern) || {}
      if path.respond_to? :to_str
        pattern[:except]  = except  if except
        pattern[:capture] = capture if capture

        if settings.respond_to? :pattern and settings.pattern?
          pattern.merge! settings.pattern do |key, local, global|
            next local unless local.is_a? Hash
            next global.merge(local) if global.is_a? Hash
            Hash.new(global).merge! local
          end
        end

        path = Mustermann19.new(path, pattern)
        condition { params.merge! path.params(captures: Array(params[:captures]), offset: -1) }
      end

      super(verb, path, block, options)
    end

    private :compile!
  end
end

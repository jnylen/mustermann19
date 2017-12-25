require 'support'
require 'mustermann19/ast/node'

describe Mustermann19::AST do
  describe :type do
    example { Mustermann19::AST::Node[:char].type     .should be == :char }
    example { Mustermann19::AST::Node[:char].new.type .should be == :char }
  end

  describe :min_size do
    example { Mustermann19::AST::Node[:char].new.min_size.should be == 1 }
    example { Mustermann19::AST::Node[:node].new.min_size.should be == 0 }
  end
end

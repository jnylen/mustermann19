require 'support'
require 'mustermann19/to_pattern'
require 'delegate'

describe Mustermann19::ToPattern do
  context String do
    example { "".to_pattern               .should be_a(Mustermann19::Sinatra) }
    example { "".to_pattern(type: :rails) .should be_a(Mustermann19::Rails)   }
  end

  context Regexp do
    example { //.to_pattern               .should be_a(Mustermann19::Regular) }
    example { //.to_pattern(type: :rails) .should be_a(Mustermann19::Regular) }
  end

  context Symbol do
    example { :foo.to_pattern               .should be_a(Mustermann19::Sinatra) }
    example { :foo.to_pattern(type: :rails) .should be_a(Mustermann19::Sinatra) }
  end

  context Array do
    example { [:foo, :bar].to_pattern               .should be_a(Mustermann19::Composite) }
    example { [:foo, :bar].to_pattern(type: :rails) .should be_a(Mustermann19::Composite) }
  end

  context Mustermann19::Pattern do
    subject(:pattern) { Mustermann19.new('') }
    example { pattern.to_pattern.should be == pattern }
    example { pattern.to_pattern(type: :rails).should be_a(Mustermann19::Sinatra) }
  end

  context 'custom class' do
    let(:example_class) do
      Class.new do
        include Mustermann19::ToPattern
        def to_s
          ":foo/:bar"
        end
      end
    end

    example { example_class.new.to_pattern                    .should be_a(Mustermann19::Sinatra) }
    example { example_class.new.to_pattern(type: :rails)      .should be_a(Mustermann19::Rails)   }
    example { Mustermann19.new(example_class.new)               .should be_a(Mustermann19::Sinatra) }
    example { Mustermann19.new(example_class.new, type: :rails) .should be_a(Mustermann19::Rails)   }
  end

  context 'primitive delegate' do
    let(:example_class) do
      Class.new(DelegateClass(Array)) do
        include Mustermann19::ToPattern
      end
    end

    example { example_class.new([:foo, :bar]).to_pattern               .should be_a(Mustermann19::Composite) }
    example { example_class.new([:foo, :bar]).to_pattern(type: :rails) .should be_a(Mustermann19::Composite) }
  end

  context 'primitive subclass' do
    let(:example_class) do
      Class.new(Array) do
        include Mustermann19::ToPattern
      end
    end

    example { example_class.new([:foo, :bar]).to_pattern               .should be_a(Mustermann19::Composite) }
    example { example_class.new([:foo, :bar]).to_pattern(type: :rails) .should be_a(Mustermann19::Composite) }
  end
end

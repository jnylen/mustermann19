require 'support'
require 'mustermann19'
require 'mustermann19/extension'
require 'sinatra/base'

describe Mustermann19 do
  describe :new do
    context "string argument" do
      example { Mustermann19.new('')                  .should be_a(Mustermann19::Sinatra)  }
      example { Mustermann19.new('', type: :identity) .should be_a(Mustermann19::Identity) }
      example { Mustermann19.new('', type: :rails)    .should be_a(Mustermann19::Rails)    }
      example { Mustermann19.new('', type: :shell)    .should be_a(Mustermann19::Shell)    }
      example { Mustermann19.new('', type: :sinatra)  .should be_a(Mustermann19::Sinatra)  }
      example { Mustermann19.new('', type: :simple)   .should be_a(Mustermann19::Simple)   }
      example { Mustermann19.new('', type: :template) .should be_a(Mustermann19::Template) }

      example { expect { Mustermann19.new('', foo:  :bar) }.to raise_error(ArgumentError, "unsupported option :foo for Mustermann19::Sinatra") }
      example { expect { Mustermann19.new('', type: :ast) }.to raise_error(ArgumentError, /unsupported type :ast/) }
    end

    context "pattern argument" do
      subject(:pattern) { Mustermann19.new('') }
      example { Mustermann19.new(pattern).should be == pattern }
      example { Mustermann19.new(pattern, type: :rails).should be_a(Mustermann19::Sinatra) }
    end

    context "regexp argument" do
      example { Mustermann19.new(//)               .should be_a(Mustermann19::Regular) }
      example { Mustermann19.new(//, type: :rails) .should be_a(Mustermann19::Regular) }
    end

    context "argument implementing #to_pattern" do
      subject(:pattern) { Class.new { def to_pattern(o={}) Mustermann19.new('foo', o) end }.new }
      example { Mustermann19.new(pattern)               .should be_a(Mustermann19::Sinatra) }
      example { Mustermann19.new(pattern, type: :rails) .should be_a(Mustermann19::Rails) }
      example { Mustermann19.new(pattern).to_s.should be == 'foo' }
    end

    context "multiple arguments" do
      example { Mustermann19.new('', '')                        .should be_a(Mustermann19::Composite) }
      example { Mustermann19.new('', '').patterns.first         .should be_a(Mustermann19::Sinatra)   }
      example { Mustermann19.new('', '').operator               .should be == :|                    }
      example { Mustermann19.new('', '', operator: :&).operator .should be == :&                    }
      example { Mustermann19.new('', '', greedy: true)          .should be_a(Mustermann19::Composite) }
    end

    context "invalid arguments" do
      it "raise a TypeError for unsupported types" do
        expect { Mustermann19.new(10) }.to raise_error(TypeError, "Integer can't be coerced into Mustermann19::Pattern")
      end
    end
  end

  describe :[] do
    example { Mustermann19[:identity] .should be == Mustermann19::Identity }
    example { Mustermann19[:rails]    .should be == Mustermann19::Rails    }
    example { Mustermann19[:shell]    .should be == Mustermann19::Shell    }
    example { Mustermann19[:sinatra]  .should be == Mustermann19::Sinatra  }
    example { Mustermann19[:simple]   .should be == Mustermann19::Simple   }
    example { Mustermann19[:template] .should be == Mustermann19::Template }

    example { expect { Mustermann19[:ast]      }.to raise_error(ArgumentError, /unsupported type :ast/) }
    example { expect { Mustermann19[:expander] }.to raise_error(ArgumentError, "unsupported type :expander") }
  end

  describe :extend_object do
    context 'special behavior for Sinatra only' do
      example { Object  .new.extend(Mustermann19).should     be_a(Mustermann19)            }
      example { Object  .new.extend(Mustermann19).should_not be_a(Mustermann19::Extension) }
      example { Class   .new.extend(Mustermann19).should     be_a(Mustermann19)            }
      example { Class   .new.extend(Mustermann19).should_not be_a(Mustermann19::Extension) }
      example { Sinatra .new.extend(Mustermann19).should_not be_a(Mustermann19)            }
      example { Sinatra .new.extend(Mustermann19).should     be_a(Mustermann19::Extension) }
    end
  end

  describe :=== do
    example { Mustermann19.should be === Mustermann19.new("") }
  end
end

require 'support'
require 'mustermann19'

describe Mustermann19::Composite do
  describe :new do
    example 'with no argument' do
      expect { Mustermann19::Composite.new }.
        to raise_error(ArgumentError, 'cannot create empty composite pattern')
    end

    example 'with one argument' do
      pattern = Mustermann19.new('/foo')
      Mustermann19::Composite.new(pattern).should be == pattern
    end
  end

  context :| do
    subject(:pattern) { Mustermann19.new('/foo/:name', '/:first/:second') }

    describe :== do
      example { subject.should     be == subject                                                       }
      example { subject.should     be == Mustermann19.new('/foo/:name', '/:first/:second')               }
      example { subject.should_not be == Mustermann19.new('/foo/:name')                                  }
      example { subject.should_not be == Mustermann19.new('/foo/:name', '/:first/:second', operator: :&) }
    end

    describe :=== do
      example { subject.should     be === "/foo/bar" }
      example { subject.should     be === "/fox/bar" }
      example { subject.should_not be === "/foo"     }
    end

    describe :params do
      example { subject.params("/foo/bar") .should be == { "name"  => "bar" }                    }
      example { subject.params("/fox/bar") .should be == { "first" => "fox", "second" => "bar" } }
      example { subject.params("/foo")     .should be_nil                                        }
    end

    describe :=== do
      example { subject.should     match("/foo/bar") }
      example { subject.should     match("/fox/bar") }
      example { subject.should_not match("/foo")     }
    end

    describe :expand do
      example { subject.should respond_to(:expand) }
      example { subject.expand(name: 'bar')                 .should be == '/foo/bar' }
      example { subject.expand(first: 'fox', second: 'bar') .should be == '/fox/bar' }

      context "without expandable patterns" do
        subject(:pattern) { Mustermann19.new('/foo/:name', '/:first/:second', type: :simple) }
        example { subject.should_not respond_to(:expand) }
        example { expect { subject.expand(name: 'bar') }.to raise_error(NotImplementedError) }
      end
    end

    describe :to_templates do
      example { should respond_to(:to_templates) }
      example { should generate_templates('/foo/{name}', '/{first}/{second}') }

      context "without patterns implementing to_templates" do
        subject(:pattern) { Mustermann19.new('/foo/:name', '/:first/:second', type: :simple) }
        example { should_not respond_to(:to_templates) }
        example { expect { subject.to_templates }.to raise_error(NotImplementedError) }
      end
    end
  end

  context :& do
    subject(:pattern) { Mustermann19.new('/foo/:name', '/:first/:second', operator: :&) }

    describe :== do
      example { subject.should     be == subject                                                       }
      example { subject.should     be == Mustermann19.new('/foo/:name', '/:first/:second', operator: :&) }
      example { subject.should_not be == Mustermann19.new('/foo/:name')                                  }
      example { subject.should_not be == Mustermann19.new('/foo/:name', '/:first/:second')               }
    end

    describe :=== do
      example { subject.should     be === "/foo/bar" }
      example { subject.should_not be === "/fox/bar" }
      example { subject.should_not be === "/foo"     }
    end

    describe :params do
      example { subject.params("/foo/bar") .should be == { "name"  => "bar" } }
      example { subject.params("/fox/bar") .should be_nil                     }
      example { subject.params("/foo")     .should be_nil                     }
    end

    describe :match do
      example { subject.should     match("/foo/bar") }
      example { subject.should_not match("/fox/bar") }
      example { subject.should_not match("/foo")     }
    end

    describe :expand do
      example { subject.should_not respond_to(:expand) }
      example { expect { subject.expand(name: 'bar') }.to raise_error(NotImplementedError) }
    end
  end

  context :^ do
    subject(:pattern) { Mustermann19.new('/foo/:name', '/:first/:second', operator: :^) }

    describe :== do
      example { subject.should     be == subject                                                       }
      example { subject.should_not be == Mustermann19.new('/foo/:name', '/:first/:second')               }
      example { subject.should_not be == Mustermann19.new('/foo/:name')                                  }
      example { subject.should_not be == Mustermann19.new('/foo/:name', '/:first/:second', operator: :&) }
    end

    describe :=== do
      example { subject.should_not be === "/foo/bar" }
      example { subject.should     be === "/fox/bar" }
      example { subject.should_not be === "/foo"     }
    end

    describe :params do
      example { subject.params("/foo/bar") .should be_nil                                        }
      example { subject.params("/fox/bar") .should be == { "first" => "fox", "second" => "bar" } }
      example { subject.params("/foo")     .should be_nil                                        }
    end

    describe :match do
      example { subject.should_not match("/foo/bar") }
      example { subject.should     match("/fox/bar") }
      example { subject.should_not match("/foo")     }
    end

    describe :expand do
      example { subject.should_not respond_to(:expand) }
      example { expect { subject.expand(name: 'bar') }.to raise_error(NotImplementedError) }
    end
  end

  describe :inspect do
    let(:sinatra)  { Mustermann19.new('x')                  }
    let(:rails)    { Mustermann19.new('x', type: :rails)    }
    let(:identity) { Mustermann19.new('x', type: :identity) }

    example { (sinatra | rails)            .inspect.should include('(sinatra:"x" | rails:"x")')                  }
    example { (sinatra ^ rails)            .inspect.should include('(sinatra:"x" ^ rails:"x")')                  }
    example { (sinatra | rails | identity) .inspect.should include('(sinatra:"x" | rails:"x" | identity:"x")')   }
    example { (sinatra | rails & identity) .inspect.should include('(sinatra:"x" | (rails:"x" & identity:"x"))') }
  end
end

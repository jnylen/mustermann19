require 'support'
require 'mustermann19/pattern'
require 'mustermann19/sinatra'
require 'mustermann19/rails'

describe Mustermann19::Pattern do
  describe :=== do
    it 'raises a NotImplementedError when used directly' do
      expect { Mustermann19::Pattern.new("") === "" }.to raise_error(NotImplementedError)
    end
  end

  describe :initialize do
    it 'raises an ArgumentError for unknown options' do
      expect { Mustermann19::Pattern.new("", foo: :bar) }.to raise_error(ArgumentError)
    end

    it 'does not complain about unknown options if ignore_unknown_options is enabled' do
      expect { Mustermann19::Pattern.new("", foo: :bar, ignore_unknown_options: true) }.not_to raise_error
    end
  end

  describe :respond_to? do
    subject(:pattern) { Mustermann19::Pattern.new("") }

    it { should_not respond_to(:expand)       }
    it { should_not respond_to(:to_templates) }

    it { expect { pattern.expand }       .to raise_error(NotImplementedError) }
    it { expect { pattern.to_templates } .to raise_error(NotImplementedError) }
  end

  describe :== do
    example { Mustermann19::Pattern.new('/foo') .should     be == Mustermann19::Pattern.new('/foo') }
    example { Mustermann19::Pattern.new('/foo') .should_not be == Mustermann19::Pattern.new('/bar') }
    example { Mustermann19::Sinatra.new('/foo') .should     be == Mustermann19::Sinatra.new('/foo') }
    example { Mustermann19::Rails.new('/foo')   .should_not be == Mustermann19::Sinatra.new('/foo') }
  end

  describe :eql? do
    example { Mustermann19::Pattern.new('/foo') .should     be_eql Mustermann19::Pattern.new('/foo') }
    example { Mustermann19::Pattern.new('/foo') .should_not be_eql Mustermann19::Pattern.new('/bar') }
    example { Mustermann19::Sinatra.new('/foo') .should     be_eql Mustermann19::Sinatra.new('/foo') }
    example { Mustermann19::Rails.new('/foo')   .should_not be_eql Mustermann19::Sinatra.new('/foo') }
  end

  describe :equal? do
    example { Mustermann19::Pattern.new('/foo') .should     be_equal Mustermann19::Pattern.new('/foo') }
    example { Mustermann19::Pattern.new('/foo') .should_not be_equal Mustermann19::Pattern.new('/bar') }
    example { Mustermann19::Sinatra.new('/foo') .should     be_equal Mustermann19::Sinatra.new('/foo') }
    example { Mustermann19::Rails.new('/foo')   .should_not be_equal Mustermann19::Sinatra.new('/foo') }
  end
end

require 'support'
require 'mustermann19/regexp_based'

describe Mustermann19::RegexpBased do
  it 'raises a NotImplementedError when used directly' do
    expect { Mustermann19::RegexpBased.new("") === "" }.to raise_error(NotImplementedError)
  end
end

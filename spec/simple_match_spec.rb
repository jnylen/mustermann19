require 'support'
require 'mustermann19/simple_match'

describe Mustermann19::SimpleMatch do
  subject { Mustermann19::SimpleMatch.new('example') }
  its(:to_s) { should be == 'example' }
  its(:names) { should be == [] }
  its(:captures) { should be == [] }
  example { subject[1].should be == nil }
end

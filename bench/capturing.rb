$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'benchmark'
require 'mustermann19'
require 'mustermann19/regexp_based'
require 'addressable/template'


Mustermann19.register(:regexp, Class.new(Mustermann19::RegexpBased) {
  def compile(**options)
    Regexp.new(@string)
  end
}, load: false)

Mustermann19.register(:addressable, Class.new(Mustermann19::RegexpBased) {
  def compile(**options)
    Addressable::Template.new(@string)
  end
}, load: false)

list = [
  [:sinatra,     '/*/:name'                                ],
  [:rails,       '/*prefix/:name'                          ],
  [:simple,      '/*/:name'                                ],
  [:template,    '{/prefix*}/{name}'                       ],
  [:regexp,      '\A\/(?<splat>.*?)\/(?<name>[^\/\?#]+)\Z' ],
  [:addressable, '{/prefix*}/{name}'                       ]
]

def self.assert(value)
  fail unless value
end

string = '/a/b/c/d'
name   = 'd'

GC.disable

puts "Compilation:"
Benchmark.bmbm do |x|
  list.each do |type, pattern|
    x.report(type) { 1_000.times { Mustermann19.new(pattern, type: type) } }
  end
end

puts "", "Matching with two captures (one splat, one normal):"
Benchmark.bmbm do |x|
  list.each do |type, pattern|
    pattern = Mustermann19.new(pattern, type: type)
    x.report type do
      10_000.times do
        match = pattern.match(string)
        assert match[:name] == name
      end
    end
  end
end

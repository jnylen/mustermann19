$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'benchmark'
require 'mustermann19/simple'
require 'mustermann19/sinatra'

[Mustermann19::Simple, Mustermann19::Sinatra].each do |klass|
  puts "", " #{klass} ".center(64, '=')
  Benchmark.bmbm do |x|
    no_capture = klass.new("/simple")
    x.report("no captures, match") { 1_000.times { no_capture.match('/simple') } }
    x.report("no captures, miss") { 1_000.times { no_capture.match('/miss') } }

    simple = klass.new("/:name")
    x.report("simple, match") { 1_000.times { simple.match('/simple').captures } }
    x.report("simple, miss") { 1_000.times { simple.match('/mi/ss') } }

    splat = klass.new("/*")
    x.report("splat, match") { 1_000.times { splat.match("/a/b/c").captures } }
    x.report("splat, miss") { 1_000.times { splat.match("/a/b/c.miss") } }
  end
  puts
end

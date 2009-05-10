require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('rbib', '1.3') do |p|
  p.description = 'BibTeX parser written in Ruby'
  p.url         = 'http://github.com/aurels/rbib'
  p.author      = 'Nick Gasson, Aurélien Malisart'
  p.email       = 'aurelien.malisart@gmail.com'
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
#!/usr/bin/env ruby

#
# Run all the unit tests in the current directory.
#

require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "bibtex"

Dir.glob(File.join(File.dirname(__FILE__), '..', 'test', 'test_*.rb')).each do |file|
  require file
end


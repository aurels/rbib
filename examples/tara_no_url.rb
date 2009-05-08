#!/usr/bin/env ruby

#
# Strip URL fields from each BibTeX file on the command line.
# Write the output to filename.stripped.bib
#

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require "bibtex"

ARGV.each do |file|
  BibTeX::Parser.parse(file).map do |entry|
    entry.reject_fields [:url]
  end.save(file.sub(/\.bib$/, '.stripped.bib'))
end

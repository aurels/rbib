#!/usr/bin/env ruby

#
# Download your CiteULike bibliography and strip
# unnecessary fields.
#

##### YOUR SETTINGS HERE #####
User = 'NickGasson'
BadFields = [:url]
##### NO NEED TO EDIT BELOW HERE #####

require 'net/http'
require 'uri'
require 'lib/bibtex/parser'

bibtex = Net::HTTP.get URI.parse("http://www.citeulike.org/bibtex/user/#{User}")
BibTeX::Parser.parse_string(bibtex).map do |entry|
  entry.reject_fields BadFields
end.save("#{User}.bib")


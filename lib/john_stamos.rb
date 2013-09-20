require 'faraday'
require 'typhoeus/adapters/faraday'
require 'nokogiri'
require 'json'
require 'launchy'

require 'john_stamos/version'
require 'john_stamos/client'
require 'john_stamos/pin_search'
require 'john_stamos/pin'
require 'john_stamos/pinner'
require 'john_stamos/extraction_helper'

module JohnStamos
  class MissingSearchText < Exception; end
  class MissingNextBookmark < Exception; end

  Faraday.default_adapter = :typhoeus

  private
    def self.uncle_jesse
      Launchy.open('http://www.youtube.com/watch?v=bLqAqIj8Rdc')
    end
end

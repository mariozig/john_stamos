require 'open-uri'
require 'nokogiri'
require 'json'
require 'rest_client'
require 'launchy'

require 'john_stamos/version'
require 'john_stamos/client'
require 'john_stamos/search_scraper'
require 'john_stamos/pin'
require 'john_stamos/pinner'

module JohnStamos
  class MissingSearchText < Exception; end
  class MissingNextBookmark < Exception; end

  private
    def self.uncle_jesse
      Launchy.open('http://www.youtube.com/watch?v=bLqAqIj8Rdc')
    end
end

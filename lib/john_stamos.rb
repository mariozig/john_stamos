require "john_stamos/version"
require "john_stamos/search_scraper"
require "john_stamos/pin"
require "john_stamos/pinner"

module JohnStamos
  class MissingSearchText < Exception; end
  class MissingNextBookmark < Exception; end

  def self.search_pins(search_terms)
    search_scraper = SearchScraper.new(search_terms)
    search_scraper.execute!
    search_scraper.pins
  end
end

require "john_stamos/version"
require "john_stamos/search_scraper"

module JohnStamos
  class MissingSearchText < Exception; end

  def self.search_pins(search_terms)
    search_scraper = SearchScraper.new(search_terms)
  end
end

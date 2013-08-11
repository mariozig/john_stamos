require 'open-uri'
require 'nokogiri'
require 'json'
require 'rest_client'

require 'john_stamos/version'
require 'john_stamos/search_scraper'
require 'john_stamos/pin'
require 'john_stamos/pinner'

module JohnStamos
  class MissingSearchText < Exception; end
  class MissingNextBookmark < Exception; end

  def self.search_pins(search_terms)
    search_scraper = SearchScraper.new(search_terms)
    search_scraper.execute!
    search_scraper.pins
  end

  def self.pin(pinterest_pin_id)
    Pin.new(pinterest_pin_id)
  end

  def self.pinner(username)
    Pinner.new(username)
  end

  def self.page_content(url)
    if JohnStamos.proxy
      proxy_uri = URI.parse(JohnStamos.proxy)
      Nokogiri::HTML(open(url, :proxy => proxy_uri))
    else
      Nokogiri::HTML(open(url))
    end
  end

  def self.json_content(url, params)
    if JohnStamos.proxy
      RestClient.proxy = JohnStamos.proxy
    end

    response = RestClient.get(url,
                              params: params,
                              :accept => :json,
                              "X-Requested-With" => "XMLHttpRequest")
    JSON.parse(response)
  end

  class << self
    attr_accessor :proxy
  end

end

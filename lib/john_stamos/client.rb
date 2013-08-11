require 'john_stamos/search_scraper'
require 'john_stamos/pin'
require 'john_stamos/pinner'

class JohnStamos::Client
  attr_accessor :proxy

  def initialize(options={})
    default_options = { proxy: nil }
    options = default_options.merge(options)

    @proxy = options[:proxy]
  end

  def search_pins(search_text)
    search_scraper = JohnStamos::SearchScraper.new(self, search_text)
    search_scraper.execute!

    search_scraper.pins
  end

  def pin(pinterest_pin_id)
    JohnStamos::Pin.new(self, { pinterest_pin_id: pinterest_pin_id } )
  end

  def pinner(username)
    JohnStamos::Pinner.new(self, username)
  end

  def page_content(url)
    if @proxy
      proxy_uri = URI.parse(@proxy)
      Nokogiri::HTML(open(url, :proxy => proxy_uri))
    else
      Nokogiri::HTML(open(url))
    end
  end

  def json_content(url, params)
    RestClient.proxy = @proxy if @proxy
    response = RestClient.get(url, params: params, accept: :json, "X-Requested-With" => "XMLHttpRequest")

    JSON.parse(response)
  end
end
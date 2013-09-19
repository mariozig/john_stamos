require 'logger'

class JohnStamos::Client
  attr_accessor :proxy

  def initialize(options={})
    default_options = { proxy: nil }
    options = default_options.merge(options)
    @proxy = options[:proxy]
  end

  def search_pins(search_text, options={})
    search_scraper = JohnStamos::PinSearch.new(self, search_text, options)
    search_scraper.execute!

    search_scraper.pins
  end

  def pin(pinterest_pin_id)
    JohnStamos::Pin.new(self, pinterest_pin_id)
  end

  def pinner(username)
    JohnStamos::Pinner.new(self, username)
  end

  def page_content(url)
    response = make_request(url)

    Nokogiri::HTML(response)
  end

  def json_content(url, params)
    response = make_json_request(url, params)

    JSON.parse(response)
  end

  private
    def make_request(url, params={}, accept_json=false)
      request_headers = build_request_headers(accept_json)

      response = pinterest_connection.get do |req|
        req.url url, params
        req.headers = request_headers
      end

      response.body
    end

    def make_json_request(url, params={})
      make_request(url, params, true)
    end

    def build_request_headers(accept_json=false)
      headers = {}

      if accept_json
        headers['Accept'] = 'application/json'
        headers['X-Requested-With'] = 'XMLHttpRequest'
      end
      headers['User-Agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36'

      headers
    end

    def pinterest_connection
      pinterest_url = 'http://www.pinterest.com'
      @pinterest_connection ||= @proxy.nil? ? Faraday.new(url: pinterest_url) : Faraday.new(url: pinterest_url, proxy: @proxy)
    end

end
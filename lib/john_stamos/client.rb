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
    response = make_request(url, params, true)

    JSON.parse(response)
  end

  private
    def make_request(url, params={}, accept_json=false)
      user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36"

      # It's OK to pass a nil proxy. Faraday simply doesn't apply proxy properties
      pinterest_connection = Faraday.new(url: 'http://pinterest.com', proxy: @proxy)

      response = pinterest_connection.get do |req|
        req.url url, params
        req.headers['User-Agent'] = user_agent
        if accept_json
          req.headers["Accept"] = "application/json"
          req.headers["X-Requested-With"] = "XMLHttpRequest"
        end
      end

      response.body
    end

end
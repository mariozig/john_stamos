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
    begin
      page = mechanize_agent.get(url)
    rescue Mechanize::ResponseReadError => e
      $stderr.puts "#{e.class}: #{e.message}"
      $stderr.puts "An error occured; attempting to force_parse"
      page = e.force_parse
    end

    page
  end

  def json_content(url, params)
    RestClient.proxy = @proxy
    response = RestClient.get(url, params: params, accept: :json, "X-Requested-With" => "XMLHttpRequest")

    JSON.parse(response)
  end

  private
    def mechanize_agent
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'

      if @proxy
        proxy_uri = URI.parse(@proxy)
        agent.set_proxy(proxy_uri.hostname, proxy_uri.port)
      end

      agent
    end

end
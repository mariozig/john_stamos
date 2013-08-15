require 'json'

class JohnStamos::Pinner
  attr_reader :username

  def initialize(client, username)
    @client = client
    @username = username
  end

  def url
    "http://pinterest.com/#{@username}/"
  end

  def pin_count
    embedded_pinner_data("pin_count")
  end

  def about
    embedded_pinner_data("about")
  end

  def follower_count
    embedded_pinner_data("follower_count")
  end

  def board_count
    embedded_pinner_data("board_count")
  end

  def avatar
    embedded_pinner_data("image_large_url")
  end

  def first_name
    embedded_pinner_data("first_name")
  end

  def last_name
    embedded_pinner_data("last_name")
  end

  def full_name
    embedded_pinner_data("full_name")
  end

  def website_url
    embedded_pinner_data("website_url")
  end

  def location
    embedded_pinner_data("location")
  end

  private
    def page
      @page ||= @client.page_content(url)
    end

    def embedded_pinner_json
      embedded_script = page.search('script').select do |script|
        script['src'].nil? && script.content.include?('Pc.startArgs')
      end

      embedded_script_content = embedded_script.first.content
      # This regex used in the range snatches the parameter Pinterest uses to
      # start their app... This parameter happens to be a JSON representation of
      # the page.
      raw_json = embedded_script_content[/Pc.startArgs = (.*);/, 1]
      embedded_script_json = JSON.parse(raw_json)

      embedded_script_json
    end

    def embedded_pinner_data(attribute)
      value = embedded_pinner_json["tree"]["options"]["module"]["data"][attribute]
      value = "" if value.nil?

      value
    end
end
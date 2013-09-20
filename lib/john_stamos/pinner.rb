require 'json'

class JohnStamos::Pinner
  attr_reader :username

  def initialize(client, username)
    @client = client
    @username = username
  end

  def url
    "http://www.pinterest.com/#{@username}/"
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
      @page ||= @client.page_content("/#{@username}/")
    end

    def embedded_pinner_data(attribute)
      embedded_pinner_json = JohnStamos::ExtractionHelper.embedded_page_json(page)

      value = embedded_pinner_json["tree"]["options"]["module"]["data"][attribute]
      value = "" if value.nil?

      value
    end
end
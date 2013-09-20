class JohnStamos::Pin
  attr_reader :id

  def initialize(client, pinterest_pin_id)
    @id = pinterest_pin_id
    @client = client
  end

  def image
    embedded_pin_data["images"]["orig"]["url"]
  end

  def video?
    embedded_pin_data("is_video")
  end

  def description
    embedded_pin_data("description")
  end

  # TODO: Make this a Board object... not just a url
  def board
    embedded_pin_data["board"]["url"]
  end

  def like_count
    embedded_pin_data("like_count")
  end

  def repin_count
    embedded_pin_data("repin_count")
  end

  def source_url
    embedded_pin_data("link")
  end

  def pinner
    JohnStamos::Pinner.new(@client, embedded_pin_data["pinner"]["username"])
  end

  def url
    "http://www.pinterest.com/pin/#{@id}/"
  end


  private
    def page
      @page ||= @client.page_content(url)
    end

    def embedded_pin_data(attribute=nil)
      embedded_pin_json = JohnStamos::ExtractionHelper.embedded_page_json(page)

      value = embedded_pin_json["tree"]["options"]["module"]["data"]

      if !attribute.nil?
        value = value[attribute]
      end

      value
    end

end
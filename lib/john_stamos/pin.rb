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
    "http://pinterest.com/pin/#{@id}/"
  end



  private
    def page
      @page ||= @client.page_content(url)
    end

    def embedded_pin_json
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

    def embedded_pin_data(attribute=nil)
      value = embedded_pin_json["tree"]["options"]["module"]["data"]

      if !attribute.nil?
        value = value[attribute]
      end

      value
    end

end
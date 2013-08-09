require 'nokogiri'
require 'open-uri'

class JohnStamos::Pin
  attr_reader :id

  def initialize(pinterest_pin_id)
    @id = pinterest_pin_id
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
    JohnStamos::Pinner.new(embedded_pin_data["pinner"]["username"])
  end

  def url
    "http://pinterest.com/pin/#{@id}/"
  end



  private
    def page
      @page ||= Nokogiri::HTML(open(url))
    end

    def embedded_pin_json
      embedded_script = page.css('script').select do |script|
        script['src'].nil? && script.content.include?('P.start(')
      end
      embedded_script_content = embedded_script.first.content
      # This regex used in the range below looks for Pinterest's call to `P.start`
      # and snatches it's parameter... which happens to be a JSON representation of
      # the page.
      raw_json = embedded_script_content[/P.start\((.*)\);$/, 1]
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
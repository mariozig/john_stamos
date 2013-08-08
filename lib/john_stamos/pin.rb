require 'nokogiri'
require 'open-uri'

class JohnStamos::Pin
  attr_reader :id

  def initialize(pinterest_pin_id)
    @id = pinterest_pin_id
  end

  def image
    sized_image_url_parts = page.xpath('//meta[@name="og:image"]/@content').first.value.split('/')
    sized_image_url_parts[3] = "originals"
    sized_image_url_parts.join('/')
  end

  def description
    page.xpath('//meta[@name="og:description"]/@content').first.value
  end

  def board_title
    page.xpath('//meta[@name="og:title"]/@content').first.value
  end

  def like_count
    page.xpath('//meta[@name="pinterestapp:likes"]/@content').first.value.to_i
  end

  def repin_count
    page.xpath('//meta[@name="pinterestapp:repins"]/@content').first.value.to_i
  end

  def source_url
    page.xpath('//meta[@name="pinterestapp:source"]/@content').first.value
  end

  def pinner
  end

  def url
    "http://pinterest.com/pin/#{@id}/"
  end

  def page
    @page ||= Nokogiri::HTML(open(url))
  end

end
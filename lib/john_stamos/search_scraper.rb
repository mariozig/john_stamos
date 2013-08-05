require 'nokogiri'
require 'open-uri'
require 'json'

class JohnStamos::SearchScraper
  attr_accessor :pins, :next_bookmark, :search_text, :pin_ids

  def initialize(search_text=nil)
    @pins, @pin_ids = [], []
    @next_bookmark = nil
    @search_text = search_text
  end

  def execute!
    raise JohnStamos::MissingSearchText if @search_text.nil?
  end

  def first_iteration_url
    raise JohnStamos::MissingSearchText if @search_text.nil?
    "http://pinterest.com/search/pins/?q=#{URI::encode(@search_text)}"
  end

  def first_retrieval
    page = Nokogiri::HTML(open(first_iteration_url))

    embedded_script = page.css('script').select do |script|
      script['src'].nil? && script.content.include?('P.start(')
    end
    embedded_script_content = embedded_script.last.content.strip!
    embedded_script_json = JSON.parse(embedded_script_content[8..-3])

    @pin_ids = pin_ids_from_first_retrieval(embedded_script_json)
    @next_bookmark = next_bookmark_from_first_retrieval(embedded_script_json)
  end

  private
    def pin_ids_from_first_retrieval(json)
      json["options"]["module"]["data"]["results"].map{ |pin| pin["id"] }
    end

    def next_bookmark_from_first_retrieval(json)
      base_search_child = json["children"].select do |child|
        next if child["resource"].nil? || child["resource"]["name"].nil?
        child["resource"]["name"] == "BaseSearchResource"
      end
      next_bookmark = base_search_child.first["resource"]["options"]["bookmarks"].first

      next_bookmark
    end

end
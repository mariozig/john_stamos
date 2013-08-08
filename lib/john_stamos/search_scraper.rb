require 'nokogiri'
require 'open-uri'
require 'json'
require 'rest_client'

class JohnStamos::SearchScraper
  attr_accessor :next_bookmark, :search_text, :pin_ids, :count
  attr_reader :count

  def initialize(search_text=nil, count=50)
    @pins, @pin_ids = [], []
    @next_bookmark = nil
    @search_text = search_text
    @count = count
  end

  def execute!
    raise JohnStamos::MissingSearchText if @search_text.nil?

    first_retrieval!

    while(@pin_ids.length < @count) do
      subsequent_retrieval!
    end
  end

  def first_retrieval_url
    raise JohnStamos::MissingSearchText if @search_text.nil?
    "http://pinterest.com/search/pins/?q=#{URI::encode(@search_text)}"
  end

  def subsequent_retrieval_url
    'http://pinterest.com/resource/SearchResource/get/'
  end

  def first_retrieval!
    page = Nokogiri::HTML(open(first_retrieval_url))

    embedded_script = page.css('script').select do |script|
      script['src'].nil? && script.content.include?('P.start(')
    end
    embedded_script_content = embedded_script.last.content.strip!
    embedded_script_json = JSON.parse(embedded_script_content[8..-3])
    pin_ids_from_embedded_script_json = pin_ids_from_first_retrieval(embedded_script_json)

    @pin_ids += pin_ids_up_to_count(pin_ids_from_embedded_script_json)
    @next_bookmark = next_bookmark_from_first_retrieval(embedded_script_json)
  end

  def subsequent_retrieval!
    raise JohnStamos::MissingNextBookmark if @next_bookmark.nil?
    raise JohnStamos::MissingSearchText if @search_text.nil?

    response = RestClient.get(subsequent_retrieval_url,
                              params: build_url_params,
                              :accept => :json,
                              "X-Requested-With" => "XMLHttpRequest")
    pins_json = JSON.parse(response)
    pin_ids_from_json = pin_ids_from_subsequent_retrieval(pins_json)

    @pin_ids += pin_ids_up_to_count(pin_ids_from_json)
    @next_bookmark = next_bookmark_from_subsequent_retrieval(pins_json)
  end

  def more_results?
    raise JohnStamos::MissingNextBookmark if @next_bookmark.nil?
    @next_bookmark != "-end-"
  end

  def count_reached?
    @count == @pin_ids.length
  end

  def pins
    @pin_ids.map do|id|
      JohnStamos::Pin.new(id)
    end
  end

  private
    def pin_ids_from_first_retrieval(json)
      json["options"]["module"]["data"]["results"].map{ |pin| pin["id"] }
    end

    def pin_ids_from_subsequent_retrieval(json)
      json["module"]["tree"]["children"].map{ |pin| pin["resource"]["options"]["id"] }
    end

    def next_bookmark_from_first_retrieval(json)
      base_search_child = json["children"].select do |child|
        next if child["resource"].nil? || child["resource"]["name"].nil?
        child["resource"]["name"] == "BaseSearchResource"
      end
      next_bookmark = base_search_child.first["resource"]["options"]["bookmarks"].first

      next_bookmark
    end

    def next_bookmark_from_subsequent_retrieval(json)
      json["module"]["tree"]["resource"]["options"]["bookmarks"].first
    end

    def build_url_params
      data_json = {
                    options: {
                      query: search_text,
                      bookmarks: [@next_bookmark],
                      show_scope_selector: true,
                      scope: "pins"
                    },
                    context: {
                      app_version: "e26ef9c"
                    },
                    "module" => {
                      name: "GridItems",
                      options: {
                        scrollable: true,
                        show_grid_footer: true,
                        centered: true,
                        reflow_all: true,
                        virtualize: true,
                        item_options: {
                          show_pinner: true,
                          show_pinned_from: false,
                          show_board: true
                        },
                        layout: "variable_height"
                      },
                      append: true,
                      error_strategy: 1
                    }
                  }

      url_params = {
                    source_url: "/search/pins/?q=#{URI::encode(search_text)}",
                    "_" => 1375127302668,
                    data: data_json.to_json
                   }
      url_params
    end

    def pin_ids_up_to_count(ids)
      remaining = @count - @pin_ids.length
      if remaining >= @pin_ids.length
        ids
      else
        ids[0..remaining-1]
      end
    end

end
class JohnStamos::PinSearch
  attr_accessor :next_bookmark, :search_text, :pin_ids, :limit

  def initialize(client, search_text=nil, options={})
    default_options = { limit: 50 }
    options = default_options.merge(options)
    @limit = options.fetch(:limit)

    @client = client
    @search_text = search_text

    @pins, @pin_ids = [], []
    @next_bookmark = nil
  end

  def execute!
    raise JohnStamos::MissingSearchText if @search_text.nil?

    first_retrieval!

    until limit_reached? do
      subsequent_retrieval!
    end
  end

  def first_retrieval_url
    raise JohnStamos::MissingSearchText if @search_text.nil?
    "/search/pins/?q=#{URI::encode(@search_text)}"
  end

  def subsequent_retrieval_url
    '/resource/SearchResource/get/'
  end

  def first_retrieval!
    page = @client.page_content(first_retrieval_url)
    embedded_script_json = JohnStamos::ExtractionHelper.embedded_page_json(page)
    pin_ids_from_embedded_script_json = pin_ids_from_first_retrieval(embedded_script_json)

    pin_ids_up_to_limit(pin_ids_from_embedded_script_json)
    @next_bookmark = next_bookmark_from_first_retrieval(embedded_script_json)
  end

  def subsequent_retrieval!
    raise JohnStamos::MissingNextBookmark if @next_bookmark.nil?
    raise JohnStamos::MissingSearchText if @search_text.nil?

    pins_json = @client.json_content(subsequent_retrieval_url, build_url_params)
    pin_ids_from_json = pin_ids_from_subsequent_retrieval(pins_json)
    pin_ids_up_to_limit(pin_ids_from_json)

    @next_bookmark = next_bookmark_from_subsequent_retrieval(pins_json)
  end

  def more_results?
    raise JohnStamos::MissingNextBookmark if @next_bookmark.nil?
    @next_bookmark != "-end-"
  end

  def limit_reached?
    @pin_ids.length == @limit.to_i
  end

  def pins
    @pin_ids.map do |pinterest_pin_id|
      JohnStamos::Pin.new(@client, pinterest_pin_id)
    end
  end

  private
    def pin_ids_from_first_retrieval(json)
      json["tree"]["options"]["module"]["data"]["results"].map{ |pin| pin["id"] }
    end

    def pin_ids_from_subsequent_retrieval(json)
      json["module"]["tree"]["children"].map{ |pin| pin["resource"]["options"]["id"] }
    end

    def next_bookmark_from_first_retrieval(json)
      base_search_child = json["tree"]["children"].select do |child|
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
                    "_" => 1379703819343,
                    data: data_json.to_json
                   }
      url_params
    end

    def pin_ids_up_to_limit(ids)
      ids.each do |id|
        break if limit_reached?
        @pin_ids << id
      end
    end

end
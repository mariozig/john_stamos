class JohnStamos::ExtractionHelper
  def self.embedded_page_json(page_content)
    seed_json_identifier = 'P.start.start'

    embedded_script = page_content.search('script').select do |script|
      script['src'].nil? && script.content.include?(seed_json_identifier)
    end

    embedded_script_content = embedded_script.last.content
    # This regex used in the range snatches the parameter Pinterest uses to
    # start their app... This parameter happens to be a JSON representation of
    # the page.
    raw_json = embedded_script_content[/#{seed_json_identifier}\((.*)\);/m, 1]

    JSON.parse(raw_json)
  end
end
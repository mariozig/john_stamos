require 'spec_helper'

describe JohnStamos::ExtractionHelper, :vcr do

  let(:pin_page_content) do
    page_with_embedded_json = 'http://www.pinterest.com/pin/412149803369441273'

    client = JohnStamos::Client.new
    client.page_content(page_with_embedded_json)
  end

  describe '.embedded_page_json' do
    it 'returns a hash' do
      described_class.embedded_page_json(pin_page_content).should be_a(Hash)
    end

    it 'returns the extracted JSON Pinterest uses to start the client side backbone app' do
      # the 'tree' key is commonly used to store page data
      # if we have this key, we have the right json blob
      described_class.embedded_page_json(pin_page_content).should have_key('tree')
    end
  end
end
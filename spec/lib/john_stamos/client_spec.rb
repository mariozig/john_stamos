require 'spec_helper'

describe JohnStamos::Client, :vcr do
  let(:client) { JohnStamos::Client.new }
  let(:pinterest_url) { 'https://pinterest.com' }

  describe '#search_pins' do
    it 'responds to #search_pins' do
      expect(client).to respond_to(:search_pins)
    end

    it 'returns the correct number of pins' do
      expect(client.search_pins('uncle jesse')).to have_exactly(50).pins
    end
  end

  describe '#pin' do
    it 'responds to #pin' do
      expect(client).to respond_to(:pin)
    end

    it 'returns a Pin' do
      expect(client.pin(412149803369441273)).to be_a(JohnStamos::Pin)
    end
  end

  describe '#pinner' do
    it 'responds to #pinner' do
      expect(client).to respond_to(:pinner)
    end

    it 'returns a Pinner' do
      expect(client.pinner('johnstamosgem')).to be_a(JohnStamos::Pinner)
    end
  end

  describe '#proxy' do
    it 'responds to #proxy' do
      expect(client).to respond_to(:proxy)
    end

    it 'initializes w/ a nil proxy by default' do
      expect(client.proxy).to be_nil
    end

    it 'initializes the proxy attribute when constructed' do
      client = JohnStamos::Client.new(proxy: 'test')
      expect(client.proxy).to eq('test')
    end
  end

  describe '#json_content' do
    it 'responds to #json_content' do
      expect(client).to respond_to(:json_content)
    end

    it 'returns a Hash' do
      RestClient.stub(:get).and_return('{"json":"json"}')

      expect(client.json_content('url', 'params')).to be_a(Hash)
    end
  end

  describe '#page_content' do
    it 'responds to #page_content' do
      expect(client).to respond_to(:page_content)
    end

    context 'when not using a proxy' do
      before(:each) { allow(client).to receive(:proxy).and_return(nil) }

      let(:page_content) { client.page_content(pinterest_url) }

      it 'returns a Nokogiri::HTML::Document' do
        expect(client.page_content(pinterest_url)).to be_a(Nokogiri::HTML::Document)
      end

      it 'does not set open-uri proxy properties' do
        expect(client).to receive(:open).with(pinterest_url).and_call_original
        page_content
      end
    end

    context 'when using a proxy' do
      let(:proxy) { 'http://proxy.com:31337' }
      let(:proxy_client) { JohnStamos::Client.new({ proxy: proxy }) }

      it 'sets open-uri proxy properties' do
        expect(proxy_client).to receive(:open).with(pinterest_url, { proxy: URI.parse(proxy) })
        proxy_client.page_content(pinterest_url)
      end
    end

  end

  describe '#json_content' do
    let(:fake_json) { '{"json":"json"}' }

    it 'responds to #json_content' do
      expect(client).to respond_to(:json_content)
    end

    context 'when not using a proxy' do
      before(:each) do
        allow(RestClient).to receive(:get).and_return(fake_json)
      end

      let(:json_content) { client.json_content('url', 'params') }

      it 'returns a Hash representation of the JSON' do
        expect(json_content).to be_a(Hash)
      end

      it 'does not set RestClient proxy properties' do
        json_content
        expect(RestClient.proxy).to be_nil
      end
    end

    context 'when using a proxy' do
      let(:proxy) { 'http://proxy.com:31337' }
      let(:proxy_client) { JohnStamos::Client.new({ proxy: proxy }) }

      before(:each) do
        allow(proxy_client).to receive(:proxy).and_return(proxy)
        allow(RestClient).to receive(:get).and_return(fake_json)
      end

      it 'sets RestClient proxy properties' do
        proxy_client.json_content('url', 'params')
        expect(RestClient.proxy).to eq(proxy_client.proxy)
      end
    end


  end
end
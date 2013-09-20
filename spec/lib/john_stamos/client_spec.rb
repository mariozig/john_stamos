require 'spec_helper'

describe JohnStamos::Client, :vcr do
  subject(:client) { JohnStamos::Client.new }
  let(:pinterest_url) { 'http://www.pinterest.com' }

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

  describe '#page_content' do
    it 'responds to #page_content' do
      expect(client).to respond_to(:page_content)
    end

    it 'returns a Nokogiri::HTML::Document object' do
      expect(client.page_content(pinterest_url)).to be_a(Nokogiri::HTML::Document)
    end
  end

  describe '#json_content' do
    let(:fake_json) { '{ "key":"value" }' }

    it 'responds to #json_content' do
      expect(client).to respond_to(:json_content)
    end

    it 'returns a Hash representation of the JSON' do
      client.stub(:make_request).and_return(fake_json)
      expect(client.json_content(nil, nil)).to be_a(Hash)
    end
  end

  describe '#make_request' do
    it 'returns a string representation of the response body' do
      response = client.send(:make_request, pinterest_url, {})
      expect(response).to be_a(String)
    end
  end

  describe '#make_json_request' do
    it 'calls #make_request with the correct params' do
      client.stub(:make_request).and_return(nil)
      expect(client).to receive(:make_request).with('a', 'b', true)

      client.send(:make_json_request, 'a', 'b')
    end
  end

  describe '#pinterest_connection' do
    context 'when using a proxy' do
      it 'creates a new Faraday proxied instance' do
        client.proxy = 'http://fakeproxy.com:1234'
        expect(Faraday).to receive(:new).with({ url: pinterest_url, proxy: client.proxy })
        client.send(:pinterest_connection)
      end
    end

    context 'when not using a proxy' do
      it 'creates a new Faraday instance' do
        client.proxy = nil
        expect(Faraday).to receive(:new).with({ url: pinterest_url })
        client.send(:pinterest_connection)
      end
    end
  end

  describe '#build_request_headers' do
    it 'has a valid User-Agent' do
      headers = client.send(:build_request_headers)
      expect(headers['User-Agent']).to eq('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.95 Safari/537.36')
    end

    context 'non-JSON requests' do
      it 'do not contain JSON request related headers' do
        headers = client.send(:build_request_headers)
        expect(headers).not_to include('Accept', 'X-Requested-With')
      end
    end

    context 'JSON requests' do
      let(:json_headers) do
        headers = {}
        headers['Accept'] = 'application/json'
        headers['X-Requested-With'] = 'XMLHttpRequest'
        headers
      end

      it 'contain JSON request related headers' do
        headers = client.send(:build_request_headers, true)
        expect(headers).to include(json_headers)
      end
    end
  end

end
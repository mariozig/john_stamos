require 'spec_helper'

describe JohnStamos::Client, :vcr do
  subject(:client) { JohnStamos::Client.new }
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

    # it 'returns a Hash' do
    #   RestClient.stub(:get).and_return('{"json":"json"}')

    #   expect(client.json_content('url', 'params')).to be_a(Hash)
    # end
  end

  # describe '#mechanize_agent' do
  #   let(:agent) { client.send(:mechanize_agent) }

  #   context 'when using a proxy' do
  #     before(:each) do
  #       client.proxy = 'http://proxy.com:4747'
  #     end

  #     it 'sets the correct hostname' do
  #       expect(agent.proxy_addr).to eq('proxy.com')
  #     end

  #     it 'sets the correct port' do
  #       expect(agent.proxy_port).to eq(4747)
  #     end
  #   end

  #   context 'when not using a proxy' do
  #     before(:each) do
  #       client.proxy = nil
  #     end

  #     it 'does not set a hostname' do
  #       expect(agent.proxy_addr).to be_nil
  #     end

  #     it 'does not set a port' do
  #       expect(agent.proxy_port).to be_nil
  #     end
  #   end
  # end

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
end
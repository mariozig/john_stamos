require 'spec_helper'

describe JohnStamos::Client, :vcr do
  let(:client) { JohnStamos::Client.new }

  describe '#search_pins' do
    it { client.should respond_to(:search_pins) }

    it 'returns the correct number of pins' do
      subject.search_pins('uncle jesse').should have_exactly(50).pins
    end
  end

  describe '.pin' do
    it { client.should respond_to(:pin) }

    it 'returns a Pin' do
      subject.pin(412149803369441273).should be_a(JohnStamos::Pin)
    end
  end

  describe '.pinner' do
    it { client.should respond_to(:pinner) }

    it 'returns a Pinner' do
      subject.pinner('johnstamosgem').should be_a(JohnStamos::Pinner)
    end
  end

  describe '.proxy' do
    it { client.should respond_to(:proxy) }

    it 'initializes w/ a nil proxy by default' do
      client.proxy.should be_nil
    end

    it 'initializes the proxy attribute when constructed' do
      client = JohnStamos::Client.new(proxy: 'test')
      client.proxy.should eq('test')
    end
  end

  describe '.page_content' do
    it { client.should respond_to(:page_content) }

    it 'returns a Nokogiri::HTML::Document' do
      client.page_content('https://pinterest.com/').should be_a(Nokogiri::HTML::Document)
    end
  end

  describe '.json_content' do
    it { client.should respond_to(:json_content) }

    it 'returns a Hash' do
      RestClient.stub(:get).and_return('{"json":"json"}')

      client.json_content('url', 'params').should be_a(Hash)
    end
  end

  context 'when using a proxy' do
    describe 'Nokogiri requests' do
      xit 'sets proxy info on OpenURI connection' do
        proxy = double('open uri proxy')
        Nokogiri.stub(:HTML).and_return(nil)
        URI.stub(:parse).and_return(proxy)
        OpenURI.should_receive(:open).with('http://google.com/',proxy).and_return(nil)
        JohnStamos.page_content('http://google.com/')
      end

    end

    describe 'RestClient requests' do
      before(:each) do
        JohnStamos.stub(:proxy).and_return('http://proxy.com')
        RestClient.stub(:get).and_return('{"json":"json"}')
      end

      it 'RestClient requests are proxied' do
        subject.json_content('url', 'params')

        RestClient.proxy.should eq(client.proxy)
      end
    end
  end

  context 'when not using a proxy' do
    describe 'Nokogiri requests' do
      xit 'does not set proxy info on OpenURI connection'
    end

    describe 'RestClient requests' do
      before(:each) do
        JohnStamos.stub(:proxy).and_return(nil)
        RestClient.stub(:get).and_return('{"json":"json"}')
      end

      it 'RestClient requests are not proxied' do
        JohnStamos.stub(:proxy).and_return(nil)
        RestClient.stub(:get).and_return('{"json":"json"}')
        subject.json_content('url', 'params')

        RestClient.proxy.should be_nil
      end
    end
  end



end
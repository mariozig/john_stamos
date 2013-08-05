require 'spec_helper'

describe JohnStamos::SearchScraper do
  it { respond_to :search_text }
  it { respond_to :next_bookmark }
  it { respond_to :pin_ids }
  it { respond_to :pins }
  it { respond_to :execute! }
  it { respond_to :first_iteration_url }

  let(:scraper) { JohnStamos::SearchScraper.new }
  let(:search_text) { "coffee roasting" }

  describe 'when initialized' do

    it 'has no search query' do
      scraper.search_text.should be_nil
    end

    it 'has no pin ids' do
      scraper.pin_ids.should be_empty
    end

    it 'has no pins' do
      scraper.pins.should be_empty
    end

    it 'has a nil next bookmark' do
      scraper.next_bookmark.should be_nil
    end
  end

  describe '#first_iteration_url' do

    context 'search query not set' do
      it 'raises an error' do
        lambda {
          scraper.first_iteration_url
        }.should raise_error(JohnStamos::MissingSearchText)
      end
    end

    it 'returns the correct URL with the search text URL encoded' do
      scraper.search_text = search_text
      scraper.first_iteration_url.should eq('http://pinterest.com/search/pins/?q=coffee%20roasting')
    end
  end

  describe '#first_retrieval' do

    context 'with results found', :vcr do
      before(:each){ scraper.search_text = search_text }

      it 'should set next_bookmark with a hash' do
        expect{scraper.first_retrieval}.to change{scraper.next_bookmark}.from(nil)
      end

      it 'should set pin_ids' do
        expect{scraper.first_retrieval}.to change{scraper.pin_ids.length}.from(0).to(50)
      end
    end

    context 'without any results found', :vcr do
      before(:each) do
        scraper.search_text = "ThisWillNeverBeFoundLOLAmIRiteYeahYoureRite"
        scraper.first_retrieval
      end

      it 'has a nil next_bookmark' do
        scraper.first_retrieval
        scraper.next_bookmark.should eq('-end-')
      end

      it 'leaves the pin_ids array empty' do
        scraper.first_retrieval
        scraper.pin_ids.should be_empty
      end
    end
  end

  describe '#execute' do
    context 'search query not set' do
      it 'raises an error' do
        lambda {
          scraper.execute!
        }.should raise_error(JohnStamos::MissingSearchText)
      end
    end

  end
end
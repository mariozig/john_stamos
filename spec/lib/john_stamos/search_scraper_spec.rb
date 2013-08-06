require 'spec_helper'
require 'base64'

describe JohnStamos::SearchScraper do
  it { should respond_to :search_text }
  it { should respond_to :next_bookmark }
  it { should respond_to :pin_ids }
  it { should respond_to :pins }
  it { should respond_to :execute! }
  it { should respond_to :first_retrieval_url }
  it { should respond_to :subsequent_retrieval_url }
  it { should respond_to :first_retrieval! }
  it { should respond_to :subsequent_retrieval! }
  it { should respond_to :more_results? }

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

  describe '#first_retrieval_url' do

    context 'search query not set' do
      it 'raises an error' do
        lambda {
          scraper.first_retrieval_url
        }.should raise_error(JohnStamos::MissingSearchText)
      end
    end

    it 'returns the correct URL with the search text URL encoded' do
      scraper.search_text = search_text
      scraper.first_retrieval_url.should eq('http://pinterest.com/search/pins/?q=coffee%20roasting')
    end
  end

  describe '#first_retrieval!' do

    context 'with results found', :vcr do
      before(:each){ scraper.search_text = search_text }

      it 'sets next_bookmark' do
        expect{ scraper.first_retrieval! }.to change{ scraper.next_bookmark }.from(nil)
      end

      it 'sets next_bookmark with a hash for the next 50 results' do
        scraper.first_retrieval!
        decrypted_hash = Base64.strict_decode64(scraper.next_bookmark)
        next_page_results_start_position = decrypted_hash.split('|')[0]
        next_page_results_start_position.should eq("oo50")
      end

      it 'should set pin_ids' do
        expect{ scraper.first_retrieval! }.to change{ scraper.pin_ids.length }.from(0).to(50)
      end
    end

    context 'without any results found', :vcr do
      before(:each) do
        scraper.search_text = "ThisWillNeverBeFoundLOLAmIRiteYeahYoureRite"
        scraper.first_retrieval!
      end

      it 'has a nil next_bookmark' do
        scraper.first_retrieval!
        scraper.next_bookmark.should eq('-end-')
      end

      it 'leaves the pin_ids array empty' do
        scraper.first_retrieval!
        scraper.pin_ids.should be_empty
      end
    end
  end

  describe '#subsequent_retrieval_url' do
    it 'returns the correct "resource" url' do
      scraper.subsequent_retrieval_url.should eq('http://pinterest.com/resource/SearchResource/get/')
    end
  end

  describe '#subsequent_retrieval' do
    it 'raises an error if there next_bookmark is not set' do
      lambda {
        scraper.search_text = "bogus search text"
        scraper.subsequent_retrieval!
      }.should raise_error(JohnStamos::MissingNextBookmark)
    end

    it 'raises an error if search_text is not set' do
      lambda {
        scraper.next_bookmark = "bogus next bookmark"
        scraper.subsequent_retrieval!
      }.should raise_error(JohnStamos::MissingSearchText)
    end

    context 'with results found', :vcr do
      before(:each) do
        scraper.search_text = 'coffee'
        scraper.first_retrieval!
      end

      it 'sets the next_bookmark' do
        expect{ scraper.subsequent_retrieval! }.to change{ scraper.next_bookmark }
      end

      it 'sets next_bookmark with a hash for the next 50 results' do
        scraper.subsequent_retrieval!
        decrypted_hash = Base64.strict_decode64(scraper.next_bookmark)
        next_page_results_start_position = decrypted_hash.split('|')[0]
        next_page_results_start_position.should eq("oo100")
      end

      it 'should append the new pin_ids' do
        expect{ scraper.subsequent_retrieval! }.to change{ scraper.pin_ids.length }.from(50).to(100)
      end
    end
  end

  describe '#more_results?' do
    context 'when there are more results' do
      before(:each) { scraper.next_bookmark = "some bogus bookmark" }
      it { scraper.more_results?.should be_true }
    end

    context 'when there are no more results' do
      before(:each) { scraper.next_bookmark = "-end-" }
      it { scraper.more_results?.should be_false }
    end

    context 'when next_bookmark is nil' do
      it 'raises a MissingNextBookmark error' do
        lambda {
        scraper.more_results?
        }.should raise_error(JohnStamos::MissingNextBookmark)
      end
    end
  end

  describe '#execute!' do
    context 'search query not set' do
      it 'raises an error' do
        lambda {
          scraper.execute!
        }.should raise_error(JohnStamos::MissingSearchText)
      end
    end

  end
end
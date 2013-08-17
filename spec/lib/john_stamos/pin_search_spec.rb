require 'spec_helper'
require 'base64'

describe JohnStamos::PinSearch, :vcr do
  subject(:scraper) { JohnStamos::PinSearch.new(client) }

  let(:client) { JohnStamos::Client.new }
  let(:search_text) { "coffee roasting" }

  it 'responds to #search_text' do
    expect(scraper).to respond_to(:search_text)
  end

  it 'responds to #next_bookmark' do
    expect(scraper).to respond_to(:next_bookmark)
  end

  it 'responds to #pin_ids' do
    expect(scraper).to respond_to(:pin_ids)
  end

  it 'responds to #limit' do
    expect(scraper).to respond_to(:limit)
  end

  it 'responds to #pins' do
    expect(scraper).to respond_to(:pins)
  end

  it 'responds to #execute!' do
    expect(scraper).to respond_to(:execute!)
  end

  it 'responds to #first_retrieval_url' do
    expect(scraper).to respond_to(:first_retrieval_url)
  end

  it 'responds to #subsequent_retrieval_url' do
    expect(scraper).to respond_to(:subsequent_retrieval_url)
  end

  it 'responds to #first_retrieval!' do
    expect(scraper).to respond_to(:first_retrieval!)
  end

  it 'responds to #subsequent_retrieval!' do
    expect(scraper).to respond_to(:subsequent_retrieval!)
  end

  it 'responds to #more_results?' do
    expect(scraper).to respond_to(:more_results?)
  end

  it 'responds to #limit_reached?' do
    expect(scraper).to respond_to(:limit_reached?)
  end


  describe 'when initialized' do
    it 'has no search query' do
      expect(scraper.search_text).to be_nil
    end

    it 'has no pin ids' do
      expect(scraper.pin_ids).to be_empty
    end

    it 'has no pins' do
      expect(scraper.pins).to be_empty
    end

    it 'has a nil next bookmark' do
      expect(scraper.next_bookmark).to be_nil
    end

    it 'has a limit of 50 by default' do
      expect(scraper.limit).to eq(50)
    end
  end

  describe '#first_retrieval_url' do
    context 'search query not set' do
      it 'raises an error' do
        expect {
          scraper.first_retrieval_url
        }.to raise_error(JohnStamos::MissingSearchText)
      end
    end

    it 'returns the correct URL with the search text URL encoded' do
      scraper.search_text = search_text
      expect(scraper.first_retrieval_url).to eq('/search/pins/?q=coffee%20roasting')
    end
  end

  describe '#first_retrieval!' do

    context 'with results found' do
      before(:each){ scraper.search_text = search_text }

      it 'sets next_bookmark' do
        expect { scraper.first_retrieval! }.to change{ scraper.next_bookmark }.from(nil)
      end

      it 'sets next_bookmark with a hash for the next 50 results' do
        scraper.first_retrieval!
        decrypted_hash = Base64.strict_decode64(scraper.next_bookmark)
        next_page_results_start_position = decrypted_hash.split('|')[0]
        next_page_results_start_position.should eq("oo50")
      end

      it 'should set pin_ids' do
        expect { scraper.first_retrieval! }.to change{ scraper.pin_ids.length }.from(0).to(50)
      end
    end

    context 'without any results found' do
      before(:each) do
        scraper.search_text = "ThisWillNeverBeFoundLOLAmIRiteYeahYoureRite"
      end

      it 'has a nil next_bookmark' do
        scraper.first_retrieval!
        expect(scraper.next_bookmark).to eq('-end-')
      end

      it 'leaves the pin_ids array empty' do
        scraper.first_retrieval!
        expect(scraper.pin_ids).to be_empty
      end
    end
  end

  describe '#subsequent_retrieval_url' do
    it 'returns the correct "resource" url' do
      expect(scraper.subsequent_retrieval_url).to eq('/resource/SearchResource/get/')
    end
  end

  describe '#subsequent_retrieval' do
    it 'raises an error if there next_bookmark is not set' do
      expect {
        scraper.search_text = "bogus search text"
        scraper.subsequent_retrieval!
      }.to raise_error(JohnStamos::MissingNextBookmark)
    end

    it 'raises an error if search_text is not set' do
      expect {
        scraper.next_bookmark = "bogus next bookmark"
        scraper.subsequent_retrieval!
      }.to raise_error(JohnStamos::MissingSearchText)
    end

    context 'with results found' do
      before(:each) do
        scraper.search_text = 'coffee'
        scraper.limit = 100
        scraper.first_retrieval!
      end

      it 'sets the next_bookmark' do
        expect { scraper.subsequent_retrieval! }.to change{ scraper.next_bookmark }
      end

      it 'sets next_bookmark with a hash for the next 50 results' do
        scraper.subsequent_retrieval!
        decrypted_hash = Base64.strict_decode64(scraper.next_bookmark)
        next_page_results_start_position = decrypted_hash.split('|')[0]
        expect(next_page_results_start_position).to eq("oo100")
      end

      it 'should append the new pin_ids' do
        # The expected count can change based on Pinterest. Sometimes they give 99, sometimes 100.
        # When you update the VCR cassettes it may cause this test to fail... please update it.
        scraper.subsequent_retrieval!
        expect(scraper.pin_ids.length).to eq(99)
      end
    end
  end

  describe '#more_results?' do
    context 'when there are more results' do
      before(:each) { scraper.next_bookmark = "some bogus bookmark" }

      it 'returns true' do
        expect(scraper.more_results?).to be_true
      end
    end

    context 'when there are no more results' do
      before(:each) { scraper.next_bookmark = "-end-" }

      it 'returns false' do
        expect(scraper.more_results?).to be_false
      end
    end

    context 'when next_bookmark is nil' do
      it 'raises a MissingNextBookmark error' do
        expect {
        scraper.more_results?
        }.to raise_error(JohnStamos::MissingNextBookmark)
      end
    end
  end

  describe '#limit_reached?' do
    context 'when the default limit of 50 has not been reached' do
      before(:each) { scraper.pin_ids = Array.new(49) }

      it 'returns false' do
        expect(scraper.limit_reached?).to be_false
      end
    end

    context 'when default limit of 50 has been reached' do
      before(:each) { scraper.pin_ids = Array.new(50) }

      it 'returns true' do
        expect(scraper.limit_reached?).to be_true
      end
    end
  end

  describe '#execute!' do

    context 'search query not set' do
      it 'raises an error' do
        expect {
          scraper.execute!
        }.to raise_error(JohnStamos::MissingSearchText)
      end
    end

    context 'when using a search term that yields thousands of pins' do
      let(:big_search_term) { "funny" }

      context 'with no limit specified' do
        subject(:big_scraper) { JohnStamos::PinSearch.new(client, big_search_term) }

        it 'limits to 50, the default' do
          big_scraper.execute!
          expect(big_scraper.limit).to eq(50)
        end

        it 'limits the pin_ids collected to 50' do
          big_scraper.execute!
          expect(big_scraper.pin_ids.length).to eq(50)
        end
      end

      context 'with a limit lower than the default' do
        subject(:big_scraper_with_small_limit) { JohnStamos::PinSearch.new(client, big_search_term, { limit: 10 }) }

        it 'limits to 10' do
          expect(big_scraper_with_small_limit.limit).to eq(10)
        end

        it 'never calls #subsequent_retrieval!' do
          expect(big_scraper_with_small_limit).to_not receive(:subsequent_retrieval!).with()
          big_scraper_with_small_limit.execute!
        end

        it 'collects the correct number of pin_ids' do
          big_scraper_with_small_limit.execute!
          expect(big_scraper_with_small_limit.pin_ids.length).to eq(10)
        end
      end

      context 'with a limit higher than the default' do
        subject(:big_scraper_with_limit) { JohnStamos::PinSearch.new(client, big_search_term, { limit: 147 }) }

        it 'limits to 147' do
          expect(big_scraper_with_limit.limit).to eq(147)
        end

        it 'collects the correct number of pin_ids' do
          expect{ big_scraper_with_limit.execute! }.to change{ big_scraper_with_limit.pin_ids.length }.from(0).to(147)
        end
      end

    end
  end

  describe '#pins' do
    let(:bogus_pinterest_ids) { [1,2] }
    before(:each) { scraper.pin_ids = bogus_pinterest_ids }

    it 'returns an Array' do
      expect(scraper.pins).to be_a(Array)
    end

    it 'contains 50 pins' do
      expect(scraper.pins).to have_exactly(bogus_pinterest_ids.length).pins
    end
  end
end
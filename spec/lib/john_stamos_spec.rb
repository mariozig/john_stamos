require 'spec_helper'

describe JohnStamos do
  it { respond_to :search_pins }

  describe '.search_pins' do
    let(:search_results) { JohnStamos.search_pins('breakfast items') }

    # xit 'should an array of pins for a search query' do
    #   results = JohnStamos.search_pins('breakfast items')
    #   results.should have_at_least(1).pins
    # end

  end

end
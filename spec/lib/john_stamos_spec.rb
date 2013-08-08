require 'spec_helper'

describe JohnStamos, :vcr do
  it { respond_to :search_pins }

  describe '.search_pins' do
    it 'returns the correct number of pins' do
      JohnStamos.search_pins('uncle jesse').should have_exactly(50).pins
    end

  end

end
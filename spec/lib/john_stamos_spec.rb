require 'spec_helper'

describe JohnStamos, :vcr do

  describe '.search_pins' do
    it { should respond_to :search_pins }

    it 'returns the correct number of pins' do
      subject.search_pins('uncle jesse').should have_exactly(50).pins
    end

  end

  describe '.pin' do
    it { should respond_to :pin }

    it 'returns a Pin' do
      subject.pin(412149803369441273).should be_a(JohnStamos::Pin)
    end
  end

  describe '.pinner' do
    it { should respond_to :pinner }

    it 'returns a Pinner' do
      subject.pinner('johnstamosgem').should be_a(JohnStamos::Pinner)
    end
  end

end
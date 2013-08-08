require 'spec_helper'

describe JohnStamos::Pin do
  let(:pin) do
    # Test pin from here: http://pinterest.com/pin/412149803369441273/
    JohnStamos:: Pin.new(412149803369441273)
  end

  it { pin.should respond_to(:id) }
  it { pin.should respond_to(:image) }
  it { pin.should respond_to(:description) }
  it { pin.should respond_to(:pinner) }
  it { pin.should respond_to(:board_title) }
  it { pin.should respond_to(:like_count) }
  it { pin.should respond_to(:repin_count) }
  it { pin.should respond_to(:source_url) }
  it { pin.should respond_to(:url) }

  it { pin.url.should eq('http://pinterest.com/pin/412149803369441273/') }

  describe 'scraped data', :vcr do
    it { pin.image.should eq('http://media-cache-ak0.pinimg.com/originals/ee/39/6e/ee396ebad5cffd3f8f6e83b5fd9f07cb.jpg') }
    it { pin.description.should eq('JohnStamosgemPin description') }
    it { pin.board_title.should eq('JohnStamosgemBoard') }
    it { pin.like_count.should eq(1) }
    it { pin.repin_count.should eq(0) }
    it { pin.source_url.should eq('http://johnstamosgem.com/') }

    describe '#pinner' do
      it 'returns a Pinner object'
    end
  end

end
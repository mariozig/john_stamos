require 'spec_helper'

describe JohnStamos::Pin do
  subject(:pin) do
    # Test pin from here: http://pinterest.com/pin/412149803369441273/
    JohnStamos::Pin.new(client, pinterest_pin_id)
  end

  let(:pinterest_pin_id) { 412149803369441273 }
  let(:client) { JohnStamos::Client.new }

  it 'responds to #id' do
    expect(pin).to respond_to(:id)
  end

  it 'has the correct id' do
    expect(pin.id).to eq(pinterest_pin_id)
  end

  it 'responds to #image' do
    expect(pin).to respond_to(:image)
  end

  it 'responds to #description' do
    expect(pin).to respond_to(:description)
  end

  it 'responds to #pinner' do
    expect(pin).to respond_to(:pinner)
  end

  it 'responds to #board' do
    expect(pin).to respond_to(:board)
  end

  it 'responds to #like_count' do
    expect(pin).to respond_to(:like_count)
  end

  it 'responds to #repin_count' do
    expect(pin).to respond_to(:repin_count)
  end

  it 'responds to #source_url' do
    expect(pin).to respond_to(:source_url)
  end

  it 'responds to #url' do
    expect(pin).to respond_to(:url)
  end

  it 'has the correct url' do
    expect(pin.url).to eq("http://pinterest.com/pin/#{pinterest_pin_id}/")
  end

  it 'responds to #video?' do
    expect(pin).to respond_to(:video?)
  end

  describe 'scraped data', :vcr do
    it 'has the correct image' do
      expect(pin.image).to eq('http://media-cache-ak0.pinimg.com/originals/ee/39/6e/ee396ebad5cffd3f8f6e83b5fd9f07cb.jpg')
    end

    it 'has the correct description' do
      expect(pin.description).to eq('JohnStamosgemPin description')
    end

    it 'belongs to the correct board' do
      expect(pin.board).to eq('/johnstamosgem/johnstamosgemboard/')
    end

    it 'has the correct like_count' do
      expect(pin.like_count).to eq(1)
    end

    it 'has the correct repin_count' do
      expect(pin.repin_count).to eq(0)
    end

    it 'has the correct source_url' do
      expect(pin.source_url).to eq('http://johnstamosgem.com/')
    end

    it 'is not a video' do
      expect(pin.video?).to be_false
    end

    describe '#pinner' do
      it 'returns a Pinner object' do
        expect(pin.pinner).to be_a(JohnStamos::Pinner)
      end

      it 'shows my fake account as the owning Pinner' do
        expect(pin.pinner.username).to eq('johnstamosgem')
      end
    end
  end

end
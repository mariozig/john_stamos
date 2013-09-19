require 'spec_helper'

describe JohnStamos::Pinner, :vcr do
  let(:client) { JohnStamos::Client.new }
  let(:pinterest_user) { 'johnstamosgem' } # Test user account from here: http://www.pinterest.com/johnstamosgem/

  subject(:pinner) { JohnStamos::Pinner.new(client, pinterest_user) }

  describe '#username' do
    it 'responds to #username' do
      expect(pinner).to respond_to(:username)
    end

    it 'returns the correct pinterest username' do
      expect(pinner.username).to eq(pinterest_user)
    end
  end

  describe '#url' do
    it 'responds to #url' do
      expect(pinner).to respond_to(:url)
    end

    it 'returns the correct url for the pinner' do
      expect(pinner.url).to eq("http://www.pinterest.com/#{pinterest_user}/")
    end
  end

  describe '#pin_count' do
    it 'responds to #pin_count' do
      expect(pinner).to respond_to(:pin_count)
    end

    it 'returns the correct number of pins' do
      expect(pinner.pin_count).to eq(1)
    end
  end

  describe '#about' do
    it 'responds to #about' do
      expect(pinner).to respond_to(:about)
    end

    it 'returns the correct about text' do
      expect(pinner.about).to eq('This is the johnstamos about content.')
    end
  end

  describe '#follower_count' do
    it 'responds to #follower_count' do
      expect(pinner).to respond_to(:follower_count)
    end

    it 'returns a follower count of 0' do
      expect(pinner.follower_count).to eq(0) # :( I have no friends.
    end
  end

  describe '#avatar' do
    it 'responds to #avatar' do
      expect(pinner).to respond_to(:avatar)
    end
    it 'returns the correct avatar URL' do
      expect(pinner.avatar).to eq('http://media-cache-ec0.pinimg.com/avatars/johnstamosgem_1375988759_140.jpg')
    end
  end

  describe 'name related attributes' do
    it 'responds to #first_name' do
      expect(pinner).to respond_to(:first_name)
    end

    it 'responds to #last_name' do
      expect(pinner).to respond_to(:last_name)
    end

    it 'responds to #full_name' do
      expect(pinner).to respond_to(:full_name)
    end

    it 'returns the correct first name' do
      expect(pinner.first_name).to  eq('John')
    end

    it 'returns the correct last name' do
      expect(pinner.last_name).to eq('Stamosgem')
    end

    it 'returns the correct full name' do
      expect(pinner.full_name).to eq('John Stamosgem')
    end
  end

  describe '#board_count' do
    it 'responds to #board_count' do
      expect(pinner).to respond_to(:board_count)
    end

    it 'returns the correct number of boards' do
      expect(pinner.board_count).to eq(1)
    end
  end

  describe '#website_url' do
    it 'responds to #website_url' do
      expect(pinner).to respond_to(:website_url)
    end

    it 'returns the correct website url' do
      expect(pinner.website_url).to eq('http://johnstamos.com/')
    end
  end

  describe '#location' do
    it 'responds to #location' do
      expect(pinner).to respond_to(:location)
    end

    it 'returns the correct location' do
      expect(pinner.location).to eq('California')
    end
  end
end
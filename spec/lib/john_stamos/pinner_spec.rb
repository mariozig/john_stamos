require 'spec_helper'

describe JohnStamos::Pinner, :vcr do
  let(:client) { JohnStamos::Client.new }

  let(:pinner) do
    # Test pin from here: http://pinterest.com/johnstamosgem/
    JohnStamos::Pinner.new(client, 'johnstamosgem')
  end

  it { pinner.should respond_to(:username) }
  it { pinner.username.should eq('johnstamosgem') }
  it { pinner.should respond_to(:url) }
  it { pinner.url.should eq('http://pinterest.com/johnstamosgem/') }

  describe "#pin_count" do
    it { pinner.should respond_to(:pin_count) }

    it 'returns the correct number of pins' do
      pinner.pin_count.should == 1
    end
  end

  describe "#follower_count" do
    it { pinner.should respond_to(:follower_count) }

    it 'returns the correct number of followers' do
      pinner.follower_count.should == 0 # :( I have no friends.
    end
  end

  describe "#avatar" do
    it { pinner.should respond_to(:avatar) }

    it 'returns the correct avatar URL' do
      pinner.avatar.should eq('http://media-cache-ec0.pinimg.com/avatars/johnstamosgem_1375988759_140.jpg')
    end
  end

  describe 'name related attributes' do
    it { pinner.should respond_to(:first_name) }
    it { pinner.should respond_to(:last_name) }
    it { pinner.should respond_to(:full_name) }

    it 'returns the first name' do
      pinner.first_name.should eq('John')
    end

    it 'returns the last name' do
      pinner.last_name.should eq('Stamosgem')
    end

    it 'returns the full name' do
      pinner.full_name.should eq('John Stamosgem')
    end
  end

  describe "#board_count" do
    it { pinner.should respond_to(:board_count) }

    it 'returns the correct number of boards' do
      pinner.board_count.should == 1
    end
  end

  describe "#website_url" do
    it { pinner.should respond_to(:website_url) }

    it 'returns the correct website url' do
      pinner_with_url = JohnStamos::Pinner.new(client, 'danielhunley')
      pinner_with_url.website_url.should == 'http://www.livingbear.com'
    end
  end

  describe "#location" do
    it { pinner.should respond_to(:location) }

    it 'returns the correct location' do
      pinner_with_location = JohnStamos::Pinner.new(client, 'danielhunley')
      pinner_with_location.location.should == "Nashville, TN"
    end
  end
end
require 'spec_helper'

describe JohnStamos do
  it "has mercy" do
    Launchy.should_receive(:open).with('http://www.youtube.com/watch?v=bLqAqIj8Rdc')
    JohnStamos.send(:uncle_jesse)
  end
end
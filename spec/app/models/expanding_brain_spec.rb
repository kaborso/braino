describe "expanding brain model" do
  it "initializes with text" do
    brains = ["first", "second", "third", "fourth"]
    eb = ExpandingBrain.new(brains)
    expect(eb.first.to_s).to eq("first")
    expect(eb.second.to_s).to eq("second")
    expect(eb.third.to_s).to eq("third")
    expect(eb.fourth.to_s).to eq("fourth")
  end
end

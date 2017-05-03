describe 'brain model' do
  it "splits up long text with carriage returns every 30 characters" do
    loooooong_text = "Here's some text with a looooooooooooong word in the first thirty characters."
    multiline_text = "Here's some text with a\nlooooooooooooong word in the\nfirst thirty characters."

    expect("#{Brain.new(loooooong_text)}").to eq(multiline_text)
  end

  it "splits up long, spaceless text with carriage returns every 30 characters" do
    loooooong_text = "Here'ssometextwithoutanyspacesjusttomakesurethisstillworks."
    multiline_text = "Here'ssometextwithoutanyspaces\njusttomakesurethisstillworks."

    expect("#{Brain.new(loooooong_text)}").to eq(multiline_text)
  end

  it "truncates 36pt text longer than 180 characters" do
    right_length = 180
    lots_of_text =  "Here's a whole lot of text that definitely will not fit in " \
                <<  "any of the boxes on the expanding brain meme image at 36pt " \
                <<  "Impact font. The max is 6 lines of 30 characters each: 180 " \
                <<  "maximum. Don't worry, we will soon support even more sizes."
    expect("#{Brain.new(lots_of_text)}".length).to eq(right_length)
  end

  it "handles nil" do
    expect("#{Brain.new(nil)}").to be_empty
  end
end

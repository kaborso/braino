describe 'expanding brain model' do
  let(:brains) { ["first", "second", "third", "fourth"] }

  describe 'instance' do
    it 'initializes with text' do
      eb = ExpandingBrain.new(brains)
      expect(eb.first.to_s).to eq("first")
      expect(eb.second.to_s).to eq("second")
      expect(eb.third.to_s).to eq("third")
      expect(eb.fourth.to_s).to eq("fourth")
    end

    describe '#generate' do
      it 'uploads image' do
        eb = ExpandingBrain.new(brains)

        # allow_any_instance_of(Brain).to receive(:render).and_return("done")
        allow(eb).to receive_message_chain(:first, :render).and_return("done")
        allow(eb).to receive_message_chain(:second, :render).and_return("done")
        allow(eb).to receive_message_chain(:third, :render).and_return("done")
        allow(eb).to receive_message_chain(:fourth, :render).and_return("done")
        allow(eb).to receive(:track).with("image.generate.timer", instance_of(Fixnum)).and_return(true)
        expect(Storage).to receive(:upload_image).and_return(true)
        allow(eb).to receive(:track).with("image.upload.timer", instance_of(Fixnum)).and_return(true)
        allow(Storage).to receive(:get_image_url).and_return(true)
        expect(eb.generate).to be_a_kind_of(String)
      end

      it 'recovers from errors while uploading' do
        eb = ExpandingBrain.new(brains)

        allow_any_instance_of(Brain).to receive(:render).and_return("done")
        allow(eb).to receive(:track).with("image.generate.timer", instance_of(Fixnum)).and_return(true)
        expect(Storage).to receive(:upload_image).and_raise(StandardError)
        allow(eb).to receive(:track).with("image.upload.timer", instance_of(Fixnum)).and_return(true)
        allow(Storage).to receive(:get_image_url).and_return(true)
        expect(eb).to receive(:track).with("error", instance_of(Fixnum)).and_return(true)
        expect(eb.generate).to be_a_kind_of(String)
      end

      it 'retrieves presigned url' do
        eb = ExpandingBrain.new(brains)

        allow_any_instance_of(Brain).to receive(:render).and_return("done")
        allow(eb).to receive(:track).with("image.generate.timer", instance_of(Fixnum)).and_return(true)
        allow(Storage).to receive(:upload_image).and_return(true)
        allow(eb).to receive(:track).with("image.upload.timer", instance_of(Fixnum)).and_return(true)
        expect(Storage).to receive(:get_image_url).and_return('https://expanding-brain.s3.us-east-2.amazonaws.com/someimage.png')
        expect(eb.generate).to be_a_kind_of(String)
      end

      it 'recovers from errors while fetching url' do
        eb = ExpandingBrain.new(brains)

        allow(eb).to receive(:track).with("image.generate.timer", instance_of(Fixnum)).and_return(true)
        allow(Storage).to receive(:upload_image).and_return(true)
        allow(eb).to receive(:track).with("image.upload.timer", instance_of(Fixnum)).and_return(true)
        expect(Storage).to receive(:get_image_url).and_raise(StandardError)
        expect(eb).to receive(:track).with("error", instance_of(Fixnum)).and_return(true)
        expect(eb.generate).to be_a_kind_of(String)
      end

      it 'returns an AWS url' do
        eb = ExpandingBrain.new(brains)

        allow(eb).to receive(:track).with("image.generate.timer", instance_of(Fixnum)).and_return(true)
        allow(Storage).to receive(:upload_image).and_return(true)
        allow(eb).to receive(:track).with("image.upload.timer", instance_of(Fixnum)).and_return(true)
        allow(Storage).to receive(:get_image_url).and_return("https://expanding-brain.s3.us-east-2.amazonaws.com/someimage.png")
        result = eb.generate

        expect(result).to be_a_kind_of(String)
        expect(result).to match("https://expanding-brain.s3.us-east-2.amazonaws.com")
      end
    end
  end

  describe 'static' do
    it '#generate returns an AWS url' do
      allow_any_instance_of(Brain).to receive(:render).and_return("done")

      allow_any_instance_of(ExpandingBrain).to receive(:track).with("image.generate.timer", instance_of(Fixnum)).and_return(true)
      allow(Storage).to receive(:upload_image).and_return(true)
      allow_any_instance_of(ExpandingBrain).to receive(:track).with("image.upload.timer", instance_of(Fixnum)).and_return(true)
      allow(Storage).to receive(:get_image_url).and_return("https://expanding-brain.s3.us-east-2.amazonaws.com/someimage.png")
      eb = ExpandingBrain.generate(brains)

      expect(eb).to be_a_kind_of(String)
      expect(eb).to match(/https:\/\/expanding-brain.s3.us-east-2.amazonaws.com/)
    end
  end
end

require 'spec_helper'

describe IndexerWorker, :elasticsearch do
  let(:indexer_spy) { double("Indexer", index: nil, delete: nil) }

  before do
    allow(Indexer).to receive(:new).and_return(indexer_spy)
  end

  describe "indexing medias" do
    let(:media) { create(:media) }

    it "updates index" do
      subject.perform("Media", :index, media.id)
      expect(Indexer).to have_received(:new).with(media, subject.logger)
      expect(indexer_spy).to have_received(:index)
    end

    it "deletes index" do
      subject.perform("Media", :delete, media.id)
      expect(Indexer).to have_received(:new).with(media, subject.logger)
      expect(indexer_spy).to have_received(:delete)
    end
  end

  describe "indexing events" do
    let(:event) { create(:event) }

    it "updates index" do
      subject.perform("Event", :index, event.id)
      expect(Indexer).to have_received(:new).with(event, subject.logger)
      expect(indexer_spy).to have_received(:index)
    end

    it "deletes index" do
      subject.perform("Event", :delete, event.id)
      expect(Indexer).to have_received(:new).with(event, subject.logger)
      expect(indexer_spy).to have_received(:delete)
    end
  end
end

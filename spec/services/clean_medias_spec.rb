require 'spec_helper'

describe CleanMedias do
  let!(:unreferenced_media) { create(:media, topic: nil) }
  let!(:referenced_media) { create(:media) }

  it "should destroy the unreferenced medias" do
    medias = Media.all
    expect(medias.count).to eq(2)
    expect(medias).to include(referenced_media)
    expect(medias).to include(unreferenced_media)

    CleanMedias.clean!
    medias = Media.all
    expect(medias.count).to eq(1)
    expect(medias).to include(referenced_media)
    expect(medias).not_to include(unreferenced_media)
  end
end

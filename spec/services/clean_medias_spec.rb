require 'spec_helper'

describe CleanMedias do
  let!(:old_unreferenced_media) { create(:media, topic: nil, created_at: 2.months.ago) }
  let!(:recent_unreferenced_media) { create(:media, topic: nil) }
  let!(:referenced_media) { create(:media) }

  it "should destroy the unreferenced medias" do
    medias = Media.all
    expect(medias.count).to eq(3)
    expect(medias).to include(referenced_media)
    expect(medias).to include(old_unreferenced_media)
    expect(medias).to include(recent_unreferenced_media)

    CleanMedias.clean!
    medias = Media.all
    expect(medias.count).to eq(2)
    expect(medias).to include(referenced_media)
    expect(medias).to include(recent_unreferenced_media)
    expect(medias).not_to include(old_unreferenced_media)
  end
end

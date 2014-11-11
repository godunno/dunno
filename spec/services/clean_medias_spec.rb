require 'spec_helper'

describe CleanMedias do
  let!(:old_unreferenced_media) { create(:media, created_at: 2.months.ago, mediable: nil) }
  let!(:recent_unreferenced_media) { create(:media, mediable: nil) }
  let!(:referenced_media) { create(:media, mediable: create(:topic)) }

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

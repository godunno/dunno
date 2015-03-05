require 'spec_helper'

describe PersonalNote do

  let(:personal_note) { build :personal_note }

  describe "associations" do
    it { is_expected.to belong_to(:event).touch(true) }
    it { is_expected.to belong_to(:media) }
  end

  describe "validations" do
    it "should have at least description or media" do
      personal_note = PersonalNote.new
      expect(personal_note).not_to be_valid
      personal_note.description = "Some description"
      expect(personal_note).to be_valid
      personal_note.description = nil
      personal_note.media = create(:media)
      expect(personal_note).to be_valid
    end
  end

  describe "callbacks" do

    describe "after create" do
      context "new personal_note" do
        it "saves a new uuid" do
          expect(personal_note.uuid).to be_nil
          personal_note.save!
          expect(personal_note.uuid).not_to be_nil
        end
      end
    end
  end

  it "should allow descriptions longer than 255 characters" do
    personal_note.description = "a" * 256
    expect { personal_note.save! }.not_to raise_error
  end
end

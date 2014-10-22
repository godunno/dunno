require 'spec_helper'

describe PersonalNote do

  let(:personal_note) { build :personal_note }

  describe "associations" do
    it { is_expected.to belong_to(:event) }
  end

  describe "callbacks" do

    describe "after create" do

      let!(:uuid) { "ead0077a-842a-4d35-b164-7cf25d610d4d" }

      context "new personal_note" do
        before(:each) do
          allow(SecureRandom).to receive(:uuid).and_return(uuid)
        end

        it "saves a new uuid" do
          expect do
            personal_note.save!
          end.to change{personal_note.uuid}.from(nil).to(uuid)
        end
      end
    end
  end
end

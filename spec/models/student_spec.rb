require 'spec_helper'

describe Student do
  describe "association" do
    it { should belong_to(:organization) }
    it { should have_and_belong_to_many(:courses) }
  end

  describe "validations" do
    [:name, :email, :password].each do |attr|
      it { should validate_presence_of(attr) }
    end
  end

  describe "callbacks" do
    describe "before save" do
      describe "ensures authentication token" do
        context "when student does not have a token" do
          let(:student) { build(:student) }

          it do
            student.save
            expect(student.authentication_token).to_not be_nil
          end
        end
        context "when student already have a token" do
          let!(:student) { create(:student) }

          it { expect{ student.save }.to_not change{ student.reload.authentication_token } }
        end
      end
    end
  end
end

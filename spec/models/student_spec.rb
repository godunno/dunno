require 'spec_helper'

describe Student do

  describe "association" do
    it { should have_many(:events) }
    it { should have_and_belong_to_many(:courses) }
  end

  describe "validations" do
    [:name, :email, :phone_number, :password].each do |attr|
      it { should validate_presence_of(attr) }
    end

    describe "#phone_number" do

      let(:student) { build :student }

      it "should be valid with correct brazilian numbers" do
        ["+55 21 9999 9999", "+55 21 99999 9999"].each do |valid_number|
          student.phone_number = valid_number
          expect(student).to have(0).errors_on(:phone_number)
        end
      end

      it "should be invalid with incorrect brazilian numbers" do
        ["+552199999999", "+55 21 9999-9999",
         "+55 (21) 9999-9999", "+552199999999"].each do |invalid_number|
          student.phone_number = invalid_number
          expect(student).to have(1).errors_on(:phone_number)
        end
      end
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

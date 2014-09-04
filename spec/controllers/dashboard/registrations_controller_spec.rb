require 'spec_helper'

describe Dashboard::RegistrationsController do
  let(:user) { build :user }

  describe "POST /users/sign_up" do
    let(:user_hash) do
      {
        user: {
          email: user.email,
          name: user.name,
          phone_number: user.phone_number,
          password: "PASSWORD",
          profile: profile
        }
      }
    end

    def do_action
      post "/users", user_hash
    end

    context "succesfully" do

      subject { User.last }
      before do
        do_action
      end

      shared_examples "creating a user" do
        it { expect(last_response.status).to eq(302) }
        it { expect(User.count).to eq(1) }
        it { expect(subject.email).to eq(user.email) }
        it { expect(subject.name).to eq(user.name) }
        it { expect(subject.phone_number).to eq(user.phone_number) }
      end

      context "creating a student" do
        let(:profile) { :student }
        it_behaves_like "creating a user"
        it { expect(subject.profile).to be_a(Student) }
      end

      context "creating a teacher" do
        let(:profile) { :teacher }
        it_behaves_like "creating a user"
        it { expect(subject.profile).to be_a(Teacher) }
      end
    end

    context "trying to create an invalid profile" do
      let(:profile) { :invalid }
      it "should fail to create an user" do
        expect{do_action}.to raise_error
        expect(User.count).to eq(0)
      end
    end
  end
end

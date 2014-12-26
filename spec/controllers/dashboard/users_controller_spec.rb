require 'spec_helper'

describe Dashboard::UsersController do
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

  describe "GET /users/accept_invitation" do
    let(:user) { create(:user) }

    context "without invitation" do
      def do_action
        get "/dashboard/users/accept_invitation"
      end

      before { do_action }

      it { expect(last_response.status).to eq(401) }
    end

    context "with invitation" do
      def do_action
        get "/dashboard/users/accept_invitation", invitation_token: user.invitation_token
      end

      before do
        Invitation.new(user).invite!
        do_action
      end

      it "should sign in the user" do
        expect_any_instance_of(Dashboard::UsersController).to receive(:sign_in).with(user)
        do_action
      end

      it { expect(last_request.env["action_controller.instance"].instance_variable_get(:@user)).to eq(user) }
    end

    context "with expired invitation" do
      def do_action
        get "/dashboard/users/accept_invitation", invitation_token: user.invitation_token
      end

      before do
        Invitation.new(user).invite!
        Timecop.freeze(1.day.from_now + Invitation::EXPIRE_AFTER)
        do_action
      end

      after { Timecop.return }

      it { expect(last_response.status).to eq(401) }
    end
  end
end

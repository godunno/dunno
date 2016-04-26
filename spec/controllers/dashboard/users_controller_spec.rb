require 'spec_helper'

describe Dashboard::UsersController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  let(:user) { build :user }

  describe "POST /users" do
    let(:user_hash) do
      {
        user: {
          email: user.email,
          name: user.name,
          password: "PASSWORD"
        }
      }
    end

    def do_action
      post :create, user_hash.merge(format: :json)
    end

    context "succesfully" do
      let(:saved_user) { User.last }
      let(:template_course) { create(:course) }
      let(:create_course_from_template) { instance_double("CreateCourseFromTemplate", create: nil) }

      before do
        ENV["TEMPLATE_COURSE_ID"] = template_course.id.to_s
        allow(TrackerWrapper).to receive_message_chain(:new, :track)
        allow(CreateCourseFromTemplate).to receive(:new).and_return(create_course_from_template)
        do_action
      end

      it { is_expected.to respond_with(201) }

      it { expect(User.count).to eq(2) }
      it { expect(saved_user.email).to eq(user.email) }
      it { expect(saved_user.name).to eq(user.name) }
      it { expect(CreateCourseFromTemplate).to have_received(:new).with(template_course, teacher: saved_user.profile) }
      it { expect(create_course_from_template).to have_received(:create) }

      context "doesn't have a template course" do
        let(:template_course) { double("fake course", id: nil) }

        it { expect(CreateCourseFromTemplate).not_to have_received(:new) }
      end
    end

    context "email already taken" do
      let!(:previous_user) { create(:user, email: user.email) }

      before do
        do_action
      end

      it "returns an error for email taken" do
        expect(JSON.parse response.body).to eq(
          "errors" => {
            "email" => ["taken"]
          }
        )
      end
    end
  end
end

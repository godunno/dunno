require 'spec_helper'

describe Dashboard::CoursesController do

  let!(:teacher) { create :teacher }
  let(:organization) { create :organization }
  let(:course) { build :course, teacher: teacher, organization: organization }

  before do
    sign_in :teacher, teacher
  end

  describe "POST #create" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      it "should create the course" do
        expect do
          post :create, course: course.attributes
        end.to change{ Course.count }.from(0).to(1)
      end

      context "creating an course" do

        before do
          post :create, course: course.attributes
        end

        subject { Course.last }

        it { expect(subject.name).to eq(course.name) }
        it { expect(subject.teacher).to eq(teacher) }
        it { expect(subject.organization).to eq(organization) }
        it { expect(subject.classroom).to eq(course.classroom) }
        it { expect(subject.start_date).to eq(course.start_date) }
        it { expect(subject.end_date).to eq(course.end_date) }
        it { expect(subject.start_time).to eq(course.start_time) }
        it { expect(subject.end_time).to eq(course.end_time) }
        it { expect(subject.weekdays).to eq(course.weekdays) }
      end

    end
  end

  describe "GET #new" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      before do
        get :new
      end

      it { expect(response).to render_template('new') }
      it { expect(assigns[:course]).to be_a Course }
    end
  end

  describe "GET #edit" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      before do
        course.save!
        get :edit, id: course.uuid
      end

      it { expect(response).to render_template('edit') }
      it { expect(assigns[:course]).to eq course }
    end
  end

  describe "PATCH #update" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      before do
        course.save!
        course.name = "NEW NAME"
        patch :update, id: course.uuid, course: course.attributes
      end

      it { expect(Course.last.name).to eq course.name }
    end
  end

  describe "DELETE #destroy" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      before do
        course.save!
      end

      it "should destroy the course" do
        expect do
          delete :destroy, id: course.uuid
        end.to change(Course, :count).by(-1)
      end
    end
  end

  describe "GET #index" do

    it_behaves_like "Dashboard authentication required"

    context "authenticated" do

      let!(:course_from_another_teacher) { create(:course, teacher: create(:teacher)) }

      before do
        course.save!
        get :index, course_id: course.uuid
      end

      it { expect(response).to render_template('index') }
      it { expect(assigns[:courses]).to include course }
      it { expect(assigns[:courses]).not_to include course_from_another_teacher }
    end
  end

end

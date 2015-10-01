require 'spec_helper'

describe CourseForm do
  describe "#update!" do
    let(:start_date) { Date.parse('2015-08-01') }
    let(:end_date) { Date.parse('2015-09-01') }
    let(:course) { create(:course, name: "Math", start_date: start_date, end_date: end_date) }
    let(:service) { CourseForm.new(course, course_params) }
    let(:persist_spy) { double("PersistPastEvents", persist!: nil) }

    context "successfully updating course" do
      context "updating attributes" do
        before do
          allow(CourseEventsIndexerWorker).to receive(:perform_async)
          allow(PersistPastEvents)
            .to receive(:new)
            .and_return(persist_spy)
        end

        context "#name" do
          let(:course_params) { { name: "Physics" } }

          it do
            expect { service.update! }
              .to change { course.name }.from("Math").to("Physics")
          end

          it do
            service.update!
            expect(CourseEventsIndexerWorker)
              .not_to have_received(:perform_async).with(course.id)
          end
        end

        context "#start_date" do
          let(:course_params) { { start_date: "2015-10-01T00:00:00.000Z", end_date: "" } }
          let(:new_start_date) { Date.parse('2015/09/30') }

          it do
            expect { service.update! }
              .to change { course.start_date }.from(start_date).to(new_start_date)
          end

          it do
            service.update!
            expect(CourseEventsIndexerWorker)
              .to have_received(:perform_async).with(course.id)
          end

          it do
            service.update!
            expect(persist_spy).not_to have_received(:persist!)
          end

          context "updating to a previous date" do
            let(:new_start_date) { start_date - 1.month }
            let(:course_params) { { start_date: new_start_date.iso8601 } }
            before do
              allow(PersistPastEvents)
                .to receive(:new)
                .with(course, since: new_start_date)
                .and_return(persist_spy)
            end

            it do
              service.update!
              expect(persist_spy).to have_received(:persist!)
            end
          end
        end

        context "#end_date" do
          let(:course_params) { { end_date: "2015-10-01T00:00:00.000Z" } }
          let(:new_end_date) { Date.parse('2015/09/30') }

          it do
            expect { service.update! }
              .to change { course.end_date }.from(end_date).to(new_end_date)
          end

          it do
            service.update!
            expect(CourseEventsIndexerWorker)
              .to have_received(:perform_async).with(course.id)
          end
        end
      end
    end

    context "failing to update an course" do
      context "with invalid name" do
        let(:course_params) { { name: "" } }

        it do
          expect { service.update! }
            .to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end

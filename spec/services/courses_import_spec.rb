require 'spec_helper'

describe CoursesImport do
  let(:teacher) { create(:profile) }
  let(:name) { "Programação II" }
  let(:class_name) { "TR302" }
  let(:start_date) { Date.parse("01-02-2015") }
  let(:end_date) { Date.parse("01-02-2015") }
  let(:weekly_schedules) do
    [
      { "weekday" => 1, "start_time" => "09:00", "end_time" => "11:00", "classroom" => "202" },
      { "weekday" => 3, "start_time" => "09:00", "end_time" => "11:00", "classroom" => "202" },
      { "weekday" => 5, "start_time" => "16:00", "end_time" => "18:00", "classroom" => "203" }
    ]
  end
  let(:url) { "http://www.example.com/disciplinas.xlsx" }
  before do
    allow(SpreadsheetParser).to receive(:parse).with(url, header_rows: 2).and_return([
      [name, class_name, start_date, end_date, '09:00', '11:00', '', 'x', '', 'x', '', '', '', "202"],
      [name, class_name, start_date, end_date, '16:00', '18:00', '', '', '', '', '', 'x', '', "203"]
    ])
  end

  describe "imports the courses" do

    before do
      CoursesImport.new(teacher, url).import!
    end

    subject { Course.first }

    it { expect(subject.name).to eq(name) }
    it { expect(subject.class_name).to eq(class_name) }
    it { expect(subject.start_date).to eq(start_date) }
    it { expect(subject.end_date).to eq(end_date) }
    it { expect(scheduler).to have_received(:schedule!) }

    describe "weekly schedule" do
      def match_weekly_schedule(weekly_schedule, target)
        attributes = weekly_schedule.attributes.slice("weekday", "start_time", "end_time", "classroom")
        expect(attributes).to eq(target)
      end
      it { match_weekly_schedule(subject.weekly_schedules.sort_by(&:weekday)[0], weekly_schedules[0]) }
      it { match_weekly_schedule(subject.weekly_schedules.sort_by(&:weekday)[1], weekly_schedules[1]) }
      it { match_weekly_schedule(subject.weekly_schedules.sort_by(&:weekday)[2], weekly_schedules[2]) }
    end
  end

  it "should accept time without leading zero" do
    allow(SpreadsheetParser).to receive(:parse).with(url, header_rows: 2).and_return([
      [name, class_name, start_date, end_date, '7:00', '9:00', '', 'x', '', '', '', '', '', "202"]
    ])
    CoursesImport.new(teacher, url).import!
    weekly_schedule = Course.first.weekly_schedules.first
    expect(weekly_schedule.start_time).to eq('07:00')
    expect(weekly_schedule.end_time).to eq('09:00')
  end

  it "should accept class name and classroom in float format" do
    allow(SpreadsheetParser).to receive(:parse).with(url, header_rows: 2).and_return([
      [name, 302.0, start_date, end_date, '7:00', '9:00', '', 'x', '', '', '', '', '', 202.0]
    ])
    CoursesImport.new(teacher, url).import!
    course = Course.first
    expect(course.class_name).to eq("302")
    expect(course.weekly_schedules.first.classroom).to eq("202")
  end

  describe "constructor method" do
    it "should call import! on an instance" do
      import = spy('TeachersImport')
      allow(CoursesImport).to receive(:new).and_return(import)
      CoursesImport.import!(url)
      expect(import).to have_received(:import!)
    end
  end
end

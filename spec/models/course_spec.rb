require 'rails_helper'

RSpec.describe Course, type: :model do
  describe "#duration" do
    let(:course) { create :course, start_at:'2001-01-01 15:30:00', end_at:'2001-01-01 16:30:00' }
    context "A course ending on an hour" do
      it "provides the duration of the course in hours" do
        expect(course.duration).to eql(1.0)
      end
    end

    context "A course ending before two hours but after an hour" do
      let(:course) { create :course, start_at:'2001-01-01 15:30:00', end_at:'2001-01-01 16:45:00' }
      it "provides a fractional duration of the course in hours" do
        expect(course.duration).to eql(1.25)
      end
    end

    context "A course ending before an hour" do
      let(:course) { create :course, start_at:'2001-01-01 15:30:00', end_at:'2001-01-01 16:15:00' }
      it "provides a fractional duration of the course in hours" do
        expect(course.duration).to eql(0.75)
      end
    end
  end
end

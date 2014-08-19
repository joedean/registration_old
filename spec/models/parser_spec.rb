require 'rails_helper'

RSpec.describe Parser, :type => :model do
  let(:parser) { Parser.new nil, nil }

  before do
    parser.course = Course.new
  end

  describe "#parse_course" do
    before do
      parser.parse_course raw_class_line
    end

    context "course has pre in it" do
      let(:raw_class_line) { "Pre-Ballet/Tap" }

      it "sets course name and category" do
        expect(parser.course.category).to eq("Ballet")
        expect(parser.course.name).to eq("Pre-Ballet/Tap")
        expect(parser.course.level).to eq("Beginner")
      end
    end

    context "course includes specific level" do
      let(:raw_class_line) { "Ballet III/IV" }

      it "sets course name and category" do
        expect(parser.course.category).to eq("Ballet")
        expect(parser.course.name).to eq("Ballet III/IV")
        expect(parser.course.level).to eq("III/IV")
      end
    end
  end

  describe "#parse_age" do
    before do
      parser.parse_age raw_age_line
    end

    context "basic age range input" do
      context "single digit ages" do
        let(:raw_age_line) { "3 - 4 yrs" }

        it "sets start_age and end_age" do
          expect(parser.course.start_age).to eq(3)
          expect(parser.course.end_age).to eq(4)
        end
      end
      context "double digit ages" do
        let(:raw_age_line) { "13 - 17 yrs" }

        it "sets start_age and end_age" do
          expect(parser.course.start_age).to eq(13)
          expect(parser.course.end_age).to eq(17)
        end
      end
    end

    context "input for adult only" do
      let(:raw_age_line) { "Adult" }

      it "sets the start age for adults only" do
        expect(parser.course.start_age).to eq(18)
        expect(parser.course.end_age).to be_nil
      end
    end

    context "input for teen/adult course" do
      let(:raw_age_line) { "Teen/Adult" }

      it "sets the start age for teens and adults" do
        expect(parser.course.start_age).to eq(13)
        expect(parser.course.end_age).to be_nil
      end
    end

    context "input for start age and up syntax" do
      context "single digit age" do
        let(:raw_age_line) { "7 and up" }

        it "sets the start age for teens and adults" do
          expect(parser.course.start_age).to eq(7)
          expect(parser.course.end_age).to be_nil
        end
      end

      context "double digit age" do
        let(:raw_age_line) { "10 and up" }

        it "sets the start age for teens and adults" do
          expect(parser.course.start_age).to eq(10)
          expect(parser.course.end_age).to be_nil
        end
      end
    end
  end

  describe "#parse_day_and_time" do

    before do
      parser.parse_day_and_time raw_day_and_time_line
    end

    context "normal date entery with non trailing or leading whitespace" do
      let(:raw_day_and_time_line) { "Tuesday 3:30 - 4:30" }

      it "sets day, start_time and end_time" do
        expect(parser.course.day).to eq("Tuesday")
        expect(parser.course.start_at.to_formatted_s(:time_only).strip).to eq('3:30 pm')
        expect(parser.course.end_at.to_formatted_s(:time_only).strip).to eq('4:30 pm')
      end

      context "Saturday morning class" do
        let(:raw_day_and_time_line) { "Saturday 9:30 - 10:30" }

        it "sets day, start_time and end_time in morning" do
          expect(parser.course.day).to eq("Saturday")
          expect(parser.course.start_at.to_formatted_s(:time_only).strip).to eq('9:30 am')
          expect(parser.course.end_at.to_formatted_s(:time_only).strip).to eq('10:30 am')
        end
      end

      context "Saturday afternoon classes" do
        let(:raw_day_and_time_line) { "Saturday 1:30 - 2:30" }

        it "sets day, start_time and end_time in afternoon" do
          expect(parser.course.day).to eq("Saturday")
          expect(parser.course.start_at.to_formatted_s(:time_only).strip).to eq('1:30 pm')
          expect(parser.course.end_at.to_formatted_s(:time_only).strip).to eq('2:30 pm')
        end
      end
    end

    context "date entry with trailing whitespace" do
      let(:raw_day_and_time_line) { "Thursday 6:30 - 7:30 " }

      it "sets day, start_time and end_time" do
        expect(parser.course.day).to eq("Thursday")
        expect(parser.course.start_at.to_formatted_s(:time_only).strip).to eq('6:30 pm')
        expect(parser.course.end_at.to_formatted_s(:time_only).strip).to eq('7:30 pm')
      end
    end

  end

  describe "#parse_studio" do
    let(:raw_studio_line) { "D" }

    before do
      parser.parse_studio raw_studio_line
    end

    it "sets studio" do
      expect(parser.course.studio).to eq("D")
    end
  end
end

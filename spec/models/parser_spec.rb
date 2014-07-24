require 'rails_helper'

RSpec.describe Parser, :type => :model do
  subject(:parser) { Parser.new nil, "SBDC" }

  describe "#parse_customer" do
    before do
      parser.parse_customer(customer)
    end

    context "only one student" do
      let(:customer) { "Dean, Johnny" }

      it "parses family and student first name" do
        expect(parser.family_name).to eq "Dean"
        expect(parser.students.map(&:first_name)).to eq ["Johnny"]
      end
    end

    context "two students" do
      let(:customer) { "Dean, Johnny & Matthew" }

      it "parses family and student first name" do
        expect(parser.family_name).to eq "Dean"
        expect(parser.students.map(&:first_name)).to eq ["Johnny", "Matthew"]
      end
    end

    context "multiple students" do
      let(:customer) { "Dean, Johnny, Matthew & Joey" }

      it "parses family and student first name" do
        expect(parser.family_name).to eq "Dean"
        expect(parser.students.map(&:first_name)).to eq ["Johnny", "Matthew", "Joey"]
      end
    end
  end

  describe "#parse_primary_contact" do
    before do
      parser.parse_primary_contact(primary_contact)
    end

    context "primary contact has only one guardian" do
      context "guardian first and last name are defined" do
        let(:primary_contact) { "Kit Dean" }

        it "parses family and guadian name" do
          expect(parser.guardian.last_name).to eq "Dean"
          expect(parser.guardian.first_name).to eq "Kit"
        end
      end

      context "guardian first, middle and last name are defined" do
        let(:primary_contact) { "Kit M. Dean" }

        it "parses family and guadian name" do
          expect(parser.guardian.last_name).to eq "Dean"
          #exdpect(parser.guardian.middle_name).to eq "M."
          expect(parser.guardian.first_name).to eq "Kit"
        end
      end
    end

    context "primary_contact has two guardians" do
      let(:primary_contact) { "Kit & Joe Dean" }

      it "parses mother and father names" do
        expect(parser.mother.first_name).to eq "Kit"
        expect(parser.mother.last_name).to eq "Dean"
        expect(parser.father.first_name).to eq "Joe"
        expect(parser.father.last_name).to eq "Dean"
      end
    end
  end

  describe "#parse_bill_to" do
    before do
      parser.parse_bill_to(bill_to)
    end

    context "no primary_contact" do
      let(:bill_to) { "Kit & Joe Dean" }

      it "parses mother and father names" do
        expect(parser.mother.first_name).to eq "Kit"
        expect(parser.mother.last_name).to eq "Dean"
        expect(parser.father.first_name).to eq "Joe"
        expect(parser.father.last_name).to eq "Dean"
      end
    end

    context "primary_contact and bill_to are the same" do
      let(:bill_to) { "Kit & Joe Dean" }
      let(:mother) { build :guardian, type: "mother", first_name: "Kit", last_name: "Dean" }
      let(:father) { build :guardian, type: "father", first_name: "Joe", last_name: "Dean" }

      before do
        parser.mother = mother
        parser.father = father
      end

      it "parses mother and father names" do
        expect(parser.mother.first_name).to eq "Kit"
        expect(parser.mother.last_name).to eq "Dean"
        expect(parser.father.first_name).to eq "Joe"
        expect(parser.father.last_name).to eq "Dean"
      end
    end

    context "primary_contact and bill_to are different" do
      let(:bill_to) { "Kit Dean" }
      let(:mother) { build :guardian, type: "mother", first_name: "Kit", last_name: "Dean" }
      let(:father) { build :guardian, type: "father", first_name: "Joe", last_name: "Dean" }

      before do
        parser.mother = mother
        parser.father = father
      end

      it "parses mother and father names" do
        expect(parser.mother.first_name).to eq "Kit"
        expect(parser.mother.last_name).to eq "Dean"
        expect(parser.father.first_name).to eq "Joe"
        expect(parser.father.last_name).to eq "Dean"
        expect(parser.guardian.first_name).to eq "Kit"
        expect(parser.guardian.last_name).to eq "Dean"
      end
    end
  end

  describe "#parse_birth_date" do
    let(:birth_date_hash) { parser.parse_birth_date(birth_date) }

    context "birth date with no name" do
      let(:birth_date) { "07/01/03" }

      it "parses the birth date" do
        expect(birth_date_hash[:birth_date]).to eq Date.new(2003, 7, 1)
        expect(birth_date_hash[:name]).to be_blank
      end
    end

    context "birth date with student name" do
      let(:birth_date) { "07/01/03 Joey" }

      it "parses the birth date" do
        expect(birth_date_hash[:birth_date]).to eq Date.new(2003, 7, 1)
        expect(birth_date_hash[:name]).to eq "Joey"
      end
    end
  end

  describe "#parse_student_birth_date" do
    before do
      parser.students = students
      parser.parse_student_birth_date(birth_date)
    end

    context "birth date with no name" do
      let(:students) { [build(:student)] }

      context "birth date with two digit year" do
        let(:birth_date) { "01/03/05" }

        it "sets first students birth date" do
          expect(parser.students.first.birth_date).to eq Date.new(2005,1,3)
        end
      end

      context "birth date with four digit year" do
        let(:birth_date) { "01/03/2005" }

        it "sets first students birth date" do
          expect(parser.students.first.birth_date).to eq Date.new(2005,1,3)
        end
      end
    end

    context "birth date with name" do
      let(:students) { [(build :student, first_name: "Johnny"),
                        (build :student, first_name: "Joey")] }
      let(:birth_date) { "01/03/05 Joey" }

      it "sets birth date of student with matching name" do
        expect(parser.students.select{ |s| s.first_name == "Joey"}.first.birth_date).to eq Date.new(2005,1,3)
      end
    end
  end
end

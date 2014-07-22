require 'rails_helper'

RSpec.describe FamiliesHelper, :type => :helper do
  describe "#age" do
    context "student birth_date is defined" do
      let(:student) { build(:student, birth_date: "10/1/2000") }

      it "gives the student age" do
        expect(helper.age(student)).to eq(14)
      end
    end

    context "student birth_date is not defined" do
      let(:student) { build(:student, birth_date: nil) }

      it "gives a '?' for age" do
        expect(helper.age(student)).go eq("?")
      end
    end
  end
end

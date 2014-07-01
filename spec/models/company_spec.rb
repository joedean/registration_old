require 'rails_helper'

RSpec.describe Company, :type => :model do

  it "should have a valid factory" do
    expect(FactoryGirl.build(:company)).to be_valid
  end

  it "should require a company name" do
    expect(FactoryGirl.build(:company, name: "")).to be_invalid
  end

  context "A list of companies" do
    let!(:sbdc) { create(:company, name: "South Bay Dance Center")  }
    let!(:coderdojo) { create(:company, name: "Coder Dojo") }

    it "orders by company name" do
      expect(Company.ordered_by_name).to eq([coderdojo, sbdc])
    end
  end
end

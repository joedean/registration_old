require 'rails_helper'

RSpec.describe Family, :type => :model do
  describe ".all_by_company" do
    context "multiple companies" do
      let!(:sbdc) { create(:company, name: "SBDC") }
      let!(:coderdojo) { create(:company, name: "CoderDojo") }
      let!(:deans) { create(:family, name: "Dean", company: sbdc) }
      let!(:roberts) { create(:family, name: "Roberts", company: sbdc) }
      let!(:browns) { create(:family, name: "Browns", company: coderdojo) }

      it "lists all families by company" do
        expect(Family.all_by_company sbdc.id).to eq([deans, roberts])
      end
    end
  end
end

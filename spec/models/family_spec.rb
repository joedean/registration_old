require 'rails_helper'

RSpec.describe Family, :type => :model do
  let!(:sbdc)            { create(:company, name: "SBDC") }
  let!(:coderdojo)       { create(:company, name: "CoderDojo") }
  let!(:browns)          { create(:family,  name: "Browns",   company: coderdojo) }
  let!(:deans)           { create(:family,  name: "Dean",     company: sbdc) }
  let!(:provines)        { create(:family,  name: "Provines", company: sbdc) }
  let!(:provine_student) { create(:student,
                                  first_name: "Deanne",
                                  family: provines,
                                  active: 1) }
  describe ".list" do
    context "when multiple companies are defined in the database" do
      let(:dojo_params) { {company_id: coderdojo.id} }
      let(:sbdc_params) { {company_id: sbdc.id} }

      context "when company id parameter is provided" do
        it "lists all families by company id parameter" do
          expect(Family.list sbdc_params).to eq([deans, provines])
        end

        context "when search query parameter is provided" do
          let(:q_param) { {q: "Bro"} }
          let(:search_params) { sbdc_params.merge q_param }
          let(:dojo_search_params) { dojo_params.merge q_param }

          it "lists all families by company matching search filter" do
            expect(Family.list dojo_search_params).to eq([browns])
          end

          context "when searching by family name" do
            let(:q_param) { { q: "rov" } }

            it "filters by search query on family name" do
              expect(Family.list search_params).to eq([provines])
            end
          end

          context "when searching by student first name" do
            let(:q_param) { { q: "ean" } }

            it "filters by search query on student first_name" do
              expect(Family.list search_params).to eq([deans, provines])
            end
          end
        end
      end
    end
  end
end

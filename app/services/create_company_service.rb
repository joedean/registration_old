class CreateCompanyService
  def call
    company = Company.find_or_create_by!(name: "South Bay Dance Center",
                                         street_address: "5899 Santa Teresa Blvd, Suite 117",
                                         city: "San Jose",
                                         state: "CA",
                                         zip: "95123",
                                         phone: "4089725679",
                                         web_site: "http://www.southbaydancecenter.com")
  end
end

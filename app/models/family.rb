class Family < ActiveRecord::Base
  has_many :students,  dependent: :destroy
  has_many :guardians, dependent: :destroy
  has_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :students,  allow_destroy: true
  accepts_nested_attributes_for :guardians, allow_destroy: true

  belongs_to :company

  def self.all_by_company company_id
    where(company_id: company_id).order(:name)
  end
end

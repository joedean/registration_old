class Family < ActiveRecord::Base
  has_many :students,  dependent: :destroy
  has_many :guardians, dependent: :destroy
  has_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :students,  allow_destroy: true
  accepts_nested_attributes_for :guardians, allow_destroy: true

  belongs_to :company

  self.per_page = 15

  def self.all_by_company options
    where(company_id: options[:company_id]).paginate(page: options[:page]).order(:name)
  end

end

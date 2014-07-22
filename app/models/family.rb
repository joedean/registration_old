class Family < ActiveRecord::Base
  has_many :students,  dependent: :destroy
  has_many :guardians, dependent: :destroy
  has_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :students,  allow_destroy: true
  accepts_nested_attributes_for :guardians, allow_destroy: true

  belongs_to :company

  self.per_page = 15

  def self.list(params)
    results = where(company_id: params[:company_id]).search(params[:q])
    results.paginate(page: params[:page]).order(:name)
  end

  def self.search(query)
    result = includes(:students).references(:students)
    return result unless query
    result.where("name LIKE :query OR students.first_name LIKE :query",
                 {query: "%#{query}%"})
  end
end

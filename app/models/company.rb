class Company < ActiveRecord::Base
  validates :name, presence: true

  has_many :families
  has_many :users

  def self.ordered_by_name
    order(:name)
  end
end

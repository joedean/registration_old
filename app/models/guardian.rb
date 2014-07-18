class Guardian < ActiveRecord::Base
  self.inheritance_column = nil

  has_many :addresses

  belongs_to :family
  belongs_to :user
end

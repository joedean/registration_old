class Guardian < ActiveRecord::Base
  has_many :addresses

  belongs_to :family
  belongs_to :user
end

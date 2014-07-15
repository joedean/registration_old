class Address < ActiveRecord::Base
  belongs_to :family
  belongs_to :student
  belongs_to :guardian
end

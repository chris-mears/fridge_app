class Fridge < ApplicationRecord
  has_many :foods
  has_many :drinks
end

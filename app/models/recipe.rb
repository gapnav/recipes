class Recipe < ApplicationRecord
  has_many :recipes_ingredients, dependent: :delete_all, inverse_of: :recipe
  accepts_nested_attributes_for :recipes_ingredients
  has_many :ingredients, through: :recipes_ingredients

  validates :title, presence: true
end

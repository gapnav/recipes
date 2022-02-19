class RecipesIngredient < ApplicationRecord
  belongs_to :recipe, required: true
  belongs_to :ingredient, required: true

  validates :title, presence: true
end
